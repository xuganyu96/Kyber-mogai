#include "kex.h"
#include "allkems.h"
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <time.h>
#include <unistd.h>

/**
 * Keep reading from the TCP connection until the specified number of bytes are
 * received. Will block until the specified number of bytes is reached or the
 * connection is dropped.
 */
size_t read_exact(int stream, uint8_t *buf, size_t buflen) {
  size_t received = 0;
  while (received < buflen) {
    size_t rxlen = read(stream, buf, buflen - received);
    if (rxlen == 0) {
      fprintf(stderr, "Connection dropped unexpectedly\n");
      exit(EXIT_FAILURE);
    }
    received += rxlen;
  }
  return received;
}

/**
 * Transmit a single public key. This is useful for sending authentication key
 * ahead of a key exchange. Returns 0 upon success.
 */
int transmit_pk(int stream, uint8_t *pk) {
  size_t txlen = send(stream, pk, KEM_PUBLICKEYBYTES, 0);
#ifdef __DEBUG__
  printf("Transmitted %lu bytes\n", txlen);
#endif
  if (txlen != KEM_PUBLICKEYBYTES) {
    fprintf(stderr, "Failed to send KEM public key\n");
    return 1;
  }
  return 0;
}

/**
 * Receive a single public key. Return 0 upon success.
 */
int receive_pk(int stream, uint8_t *pk) {
  size_t rxlen = read_exact(stream, pk, KEM_PUBLICKEYBYTES);
#ifdef __DEBUG__
  printf("Received %lu bytes\n", rxlen);
#endif
  if (rxlen != KEM_PUBLICKEYBYTES) {
    fprintf(stderr, "Failed to receive KEM public key\n");
    return 1;
  }
  return 0;
}

/**
 * Server-side handler for key exchange.
 *
 * Return 0 upon success.
 *
 * Client's transmission must either contain exactly etm_publickeybytes bytes
 * (when doing unauthenticated key exchange) or exactly (etm_publickeybytes +
 * etm_ciphertextbytes) bytes (for doing server authentication). If client
 * transmission contains server authentication, but server's secret key is not
 * provided, then server should abort the key exchange.
 *
 * If client public key is provided, then server's transmission contains
 * (ephemeral ciphertext || client authentication). Otherwise, server's
 * transmission contains only ephemeral ciphertext.
 *
 * When deriving the session key, only non-empty shared secrets will be absorbed
 * into the Keccak. Shared secrets will always be absorbed in this order:
 * ephemeral, server authentication, client authentication.
 */
int server_handle(int stream, uint8_t *sk_server, uint8_t *pk_client,
                  uint8_t *session_key, size_t session_key_len) {
  uint8_t prekey[3 * KEM_BYTES];
  uint8_t client_tx[KEM_PUBLICKEYBYTES + KEM_CIPHERTEXTBYTES];
  uint8_t server_tx[2 * KEM_CIPHERTEXTBYTES];
  uint8_t *ss_e = prekey; // length is unnecessary since ss_e is required
  uint8_t *ss_server_auth = prekey + KEM_BYTES;
  size_t ss_server_auth_len = 0;
  uint8_t *ss_client_auth = prekey + KEM_BYTES * 2;
  size_t ss_client_auth_len = 0;
  uint8_t *pk_e = client_tx;
  uint8_t *ct_server_auth = client_tx + KEM_PUBLICKEYBYTES;
  size_t ct_server_auth_len = 0;
  uint8_t *ct_e = server_tx;
  uint8_t *ct_client_auth = server_tx + KEM_CIPHERTEXTBYTES;
  size_t ct_client_auth_len = 0;

  // if sk_server is not NULL, then server is expecting both ephemeral public
  // key and server authentication ciphertext; else server is only expecting
  // ephemeral public key
  size_t rx_len = sk_server ? (KEM_PUBLICKEYBYTES + KEM_CIPHERTEXTBYTES)
                            : KEM_PUBLICKEYBYTES;
  read_exact(stream, client_tx, rx_len);

  // Process client transmission
  if (sk_server) {
    kem_dec(ss_server_auth, ct_server_auth, sk_server);
    ss_server_auth_len = KEM_BYTES;
  }

  // construct server response
  kem_enc(ct_e, ss_e, pk_e);
  if (pk_client) {
    kem_enc(ct_client_auth, ss_client_auth, pk_client);
    ss_client_auth_len = KEM_BYTES;
    ct_client_auth_len = KEM_CIPHERTEXTBYTES;
  }
  // send server response
  size_t tx_len;
  if (ct_client_auth_len == KEM_CIPHERTEXTBYTES) {
    tx_len = send(stream, server_tx, KEM_CIPHERTEXTBYTES * 2, 0);
    if (tx_len != KEM_CIPHERTEXTBYTES * 2) {
      fprintf(stderr, "ERROR: server failed to send response\n");
      return 1;
    }
  } else {
    tx_len = send(stream, server_tx, KEM_CIPHERTEXTBYTES, 0);
    if (tx_len != KEM_CIPHERTEXTBYTES) {
      fprintf(stderr, "ERROR: server failed to send response\n");
      return 1;
    }
  }

  // derive session key
  keccak_state state;
  shake256_init(&state);
  shake256_absorb(&state, ss_e, KEM_BYTES);
  if (ss_server_auth_len == KEM_BYTES) {
    shake256_absorb(&state, ss_server_auth, KEM_BYTES);
  }
  if (ss_client_auth_len == KEM_BYTES) {
    shake256_absorb(&state, ss_client_auth, KEM_BYTES);
  }
  shake256_finalize(&state);
  shake256_squeeze(session_key, session_key_len, &state);
  return 0;
}

/**
 * Client-side handler for key exchange.
 *
 * Return 0 upon success.
 *
 * In each key exchange, the client is responsible for running the key
 * generation routine and sending the first transmission. Depending on whether
 * server and/or client authentication is needed, the content of client's
 * transmission, and the server's response, will vary.
 * - in unauthenticated key exchange, client only sends the ephemeral public
 *   key, and server only responds with ephemeral ciphertext
 * - if server authentication is required, then caller needs to pass in server's
 *   public key; client transmission will contain (ephemeral public key ||
 *   server authentciation ciphertext); server transmissions will contain only
 *   the ephemeral ciphertext
 * - if both server authentication and client authentication are required, then
 *   caller needs to pass in server's public key and client's secret key. Client
 *   transmission will contain (ephemeral public key || server authentication
 *   ciphertext); server transmission should contain (ephemeral ciphertext ||
 *   client authentication ciphertext)
 *
 * TODO: at this moment both client and server needs to know ahead of time
 * the authentication mode (none/server/client/all); if we want client and/or
 * server to be able to detect authentication mode DURING the key exchange
 * (instead of BEFORE the key exchange), then the communication protocol will
 * need to contain special message to transmit that message. This is because
 * there is no way of knowing how many bytes to read from a TCP connection.
 */
int client_handle(int stream, uint8_t *sk_client, uint8_t *pk_server,
                  uint8_t *session_key, size_t session_key_len) {
  uint8_t prekey[3 * KEM_BYTES];
  uint8_t client_tx[KEM_PUBLICKEYBYTES + KEM_CIPHERTEXTBYTES];
  uint8_t server_tx[2 * KEM_CIPHERTEXTBYTES];
  uint8_t *ss_e = prekey; // length is unnecessary since ss_e is required
  uint8_t *ss_server_auth = prekey + KEM_BYTES;
  size_t ss_server_auth_len = 0;
  uint8_t *ss_client_auth = prekey + KEM_BYTES * 2;
  size_t ss_client_auth_len = 0;
  uint8_t *pk_e = client_tx;
  uint8_t *ct_server_auth = client_tx + KEM_PUBLICKEYBYTES;
  size_t ct_server_auth_len = 0;
  uint8_t *ct_e = server_tx;
  uint8_t *ct_client_auth = server_tx + KEM_CIPHERTEXTBYTES;
  size_t ct_client_auth_len = 0;
  uint8_t sk_e[KEM_SECRETKEYBYTES];

  // Prepare client transmission
  kem_keypair(pk_e, sk_e);
  if (pk_server) {
    kem_enc(ct_server_auth, ss_server_auth, pk_server);
    ct_server_auth_len = KEM_CIPHERTEXTBYTES;
    ss_server_auth_len = KEM_BYTES;
  }

  // Send client transmission to server
  ssize_t client_txlen = pk_server ? (KEM_PUBLICKEYBYTES + KEM_CIPHERTEXTBYTES)
                                   : KEM_PUBLICKEYBYTES;
  if (send(stream, client_tx, client_txlen, 0) < 0) {
    fprintf(stderr, "Client failed to transmit %ld bytes\n", client_txlen);
    return 1;
  }

  // If client secret key is not NULL, then client is expecting both ephemeral
  // ciphertext and client authentication ciphertext; else, client is only
  // expecting ephemeral ciphertext.
  size_t server_resp_len = sk_client
                               ? (KEM_CIPHERTEXTBYTES + KEM_CIPHERTEXTBYTES)
                               : KEM_CIPHERTEXTBYTES;
  read_exact(stream, server_tx, server_resp_len);

  // Process server response
  kem_dec(ss_e, ct_e, sk_e);
  if (ct_client_auth_len == KEM_CIPHERTEXTBYTES) {
    kem_dec(ss_client_auth, ct_client_auth, sk_client);
    ss_client_auth_len = KEM_BYTES;
  }

  // derive session key
  keccak_state state;
  shake256_init(&state);
  shake256_absorb(&state, ss_e, KEM_BYTES);
  if (ss_server_auth_len == KEM_BYTES) {
    shake256_absorb(&state, ss_server_auth, KEM_BYTES);
  }
  if (ss_client_auth_len == KEM_BYTES) {
    shake256_absorb(&state, ss_client_auth, KEM_BYTES);
  }
  shake256_finalize(&state);
  shake256_squeeze(session_key, session_key_len, &state);

  return 0;
}

/**
 * Command-line argument parsing
 *
 * There are exactly four arguments: <auth_mode> <host> <port>. Return
 * 0 if parsing is successful
 *
 * Authentication mode must be exactly one of "none(0)", "server(1)",
 * "client(2)", "all(3)", indicating no authentication, authenticating only
 * server, authenticating only client, and mutual authentication.
 *
 * Host is used by the client to connect to the server. Host will be ignored by
 * server.
 *
 * Port is used by the server to set up the listener, and used by the client to
 * connect to the server
 */
int parse_args(int argc, char *argv[], int *auth_mode, char *host, int *port) {
  if (argc != 4) {
    fprintf(stderr, "Usage: kex <none|server|client|all> <host> <port>\n");
    return 1;
  }

  if (strcmp(argv[1], "none") == 0) {
    *auth_mode = 0;
  } else if (strcmp(argv[1], "server") == 0) {
    *auth_mode = 1;
  } else if (strcmp(argv[1], "client") == 0) {
    *auth_mode = 2;
  } else if (strcmp(argv[1], "all") == 0) {
    *auth_mode = 3;
  } else {
    fprintf(stderr,
            "Auth mode must be \"none\", \"server\", \"client\", or \"all\"\n");
    return 1;
  }

  // TODO: need to validate host and port number
  if (host) {
    strcpy(host, argv[2]);
  }
  *port = atoi(argv[3]);

  return 0;
}

/**
 * Debug networking peer
 *
 * Retrieve and display the host name and port of the peer
 */
void debug_network_peer(int stream) {
  // get and display peer's address
  struct sockaddr_in peer_addr;
  size_t peer_addr_len = sizeof(peer_addr);
  char peer_addr_str[INET_ADDRSTRLEN];
  getpeername(stream, (struct socketaddr *)&peer_addr,
              (socklen_t *)&peer_addr_len);
  inet_ntop(AF_INET, &(peer_addr.sin_addr), peer_addr_str, INET_ADDRSTRLEN);
  int peer_port = ntohs(peer_addr.sin_port);
  printf("Connected to %s:%d\n", peer_addr_str, peer_port);
}
