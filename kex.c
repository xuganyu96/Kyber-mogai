#include "kex.h"
#include "etm.h"
#include "utils.h"
#include "kyber/ref/fips202.h"
#include "kyber/ref/kem.h"
#include <stdint.h>
#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>

/**
 * Read exactly data_len bytes from fd. Return 0 on success
 */
int fread_exact(FILE *fd, uint8_t *data, size_t data_len) {
  size_t file_len = fread(data, data_len, 1, fd);
  return file_len - data_len;
}

int server_handle(int stream, uint8_t *sk_server, uint8_t *pk_client,
                  uint8_t *session_key, size_t session_key_len) {
  uint8_t prekey[3 * ETM_SESSIONKEYBYTES];
  uint8_t client_tx[ETM_PUBLICKEYBYTES + ETM_CIPHERTEXTBYTES];
  uint8_t server_tx[2 * ETM_CIPHERTEXTBYTES];
  uint8_t *ss_e = prekey; // length is unnecessary since ss_e is required
  uint8_t *ss_server_auth = prekey + ETM_SESSIONKEYBYTES;
  size_t ss_server_auth_len = 0;
  uint8_t *ss_client_auth = prekey + ETM_SESSIONKEYBYTES * 2;
  size_t ss_client_auth_len = 0;
  uint8_t *pk_e = client_tx;
  uint8_t *ct_server_auth = client_tx + ETM_PUBLICKEYBYTES;
  size_t ct_server_auth_len = 0;
  uint8_t *ct_e = server_tx;
  uint8_t *ct_client_auth = server_tx + ETM_CIPHERTEXTBYTES;
  size_t ct_client_auth_len = 0;

  printf("Waiting for client transmission...\n");
  size_t rx_len = read(stream, client_tx, sizeof(client_tx));
  if (rx_len == ETM_PUBLICKEYBYTES) {
    printf("Client did not request server authentication\n");
  } else if (rx_len == ETM_PUBLICKEYBYTES + ETM_CIPHERTEXTBYTES) {
    printf("Client requested server authentication\n");
    if (!sk_server) {
      fprintf(stderr, "ERROR: Server secret key is not ready\n");
      return 1;
    }
    ct_server_auth_len = ETM_CIPHERTEXTBYTES;
  } else {
    fprintf(stderr,
            "ERROR: Client transmission is malformed. Aborting key exchange\n");
    return 1;
  }
  // Process client transmission
  if (ct_server_auth_len == ETM_CIPHERTEXTBYTES) {
    if (0 != etm_decap(ct_server_auth, ss_server_auth, sk_server)) {
      fprintf(stderr,
              "ERROR: server failed to decapsulate server authentication\n");
      return 1;
    } else {
      ss_server_auth_len = ETM_SESSIONKEYBYTES;
    }
  }

  // construct server response
  if (0 != etm_encap(ct_e, ss_e, pk_e)) {
    fprintf(stderr, "ERROR: server failed to encapsulate ephemeral secret\n");
    return 1;
  }
  if (pk_client) {
    if (0 != etm_encap(ct_client_auth, ss_client_auth, pk_client)) {
      fprintf(stderr,
              "ERROR: server failed to encapsulate client authentication\n");
      return 1;
    } else {
      printf("Server requested client authentication\n");
      ss_client_auth_len = ETM_SESSIONKEYBYTES;
      ct_client_auth_len = ETM_CIPHERTEXTBYTES;
    }
  }
  // send server response
  size_t tx_len;
  if (ct_client_auth_len == ETM_CIPHERTEXTBYTES) {
    tx_len = send(stream, server_tx, ETM_CIPHERTEXTBYTES * 2, 0);
    if (tx_len != ETM_CIPHERTEXTBYTES * 2) {
      fprintf(stderr, "ERROR: server failed to send response\n");
      return 1;
    }
  } else {
    tx_len = send(stream, server_tx, ETM_CIPHERTEXTBYTES, 0);
    if (tx_len != ETM_CIPHERTEXTBYTES) {
      fprintf(stderr, "ERROR: server failed to send response\n");
      return 1;
    }
  }

  // derive session key
  keccak_state state;
  shake256_init(&state);
  printf("Ephemeral shared secret: ");
  print_hexstr(ss_e, ETM_SESSIONKEYBYTES);
  shake256_absorb(&state, ss_e, ETM_SESSIONKEYBYTES);
  if (ss_server_auth_len == ETM_SESSIONKEYBYTES) {
    printf("Server authentication: ");
    print_hexstr(ss_server_auth, ETM_SESSIONKEYBYTES);
    shake256_absorb(&state, ss_e, ETM_SESSIONKEYBYTES);
  }
  if (ss_client_auth_len == ETM_SESSIONKEYBYTES) {
    printf("Client authentication: ");
    print_hexstr(ss_client_auth, ETM_SESSIONKEYBYTES);
    shake256_absorb(&state, ss_e, ETM_SESSIONKEYBYTES);
  }
  shake256_finalize(&state);
  shake256_squeeze(session_key, session_key_len, &state);
  return 0;
}

int client_handle(int stream, uint8_t *sk_client, uint8_t *pk_server,
                  uint8_t *session_key, size_t session_key_len) {
  uint8_t prekey[3 * ETM_SESSIONKEYBYTES];
  uint8_t client_tx[ETM_PUBLICKEYBYTES + ETM_CIPHERTEXTBYTES];
  uint8_t server_tx[2 * ETM_CIPHERTEXTBYTES];
  uint8_t *ss_e = prekey; // length is unnecessary since ss_e is required
  uint8_t *ss_server_auth = prekey + ETM_SESSIONKEYBYTES;
  size_t ss_server_auth_len = 0;
  uint8_t *ss_client_auth = prekey + ETM_SESSIONKEYBYTES * 2;
  size_t ss_client_auth_len = 0;
  uint8_t *pk_e = client_tx;
  uint8_t *ct_server_auth = client_tx + ETM_PUBLICKEYBYTES;
  size_t ct_server_auth_len = 0;
  uint8_t *ct_e = server_tx;
  uint8_t *ct_client_auth = server_tx + ETM_CIPHERTEXTBYTES;
  size_t ct_client_auth_len = 0;
  uint8_t sk_e[ETM_SECRETKEYBYTES];

  // Prepare client transmission
  crypto_kem_keypair(pk_e, sk_e);
  if (pk_server) {
    printf("Client requested server authentication\n");
    etm_encap(ct_server_auth, ss_server_auth, pk_server);
    ct_server_auth_len = ETM_CIPHERTEXTBYTES;
    ss_server_auth_len = ETM_SESSIONKEYBYTES;
  }

  // Send client transmission to server
  ssize_t expected_tx_len;
  if (ct_server_auth_len == 0) {
    expected_tx_len = ETM_PUBLICKEYBYTES;
  } else {
    expected_tx_len = ETM_PUBLICKEYBYTES + ETM_CIPHERTEXTBYTES;
  }
  if (expected_tx_len != send(stream, client_tx, expected_tx_len, 0)) {
    fprintf(stderr, "Client failed to transmit %ld bytes\n", expected_tx_len);
    return 1;
  }

  // Receive server response
  size_t rx_len = read(stream, server_tx, sizeof(server_tx));
  if (rx_len == ETM_CIPHERTEXTBYTES) {
    printf("Server did not request client authentication\n");
  } else if (rx_len == 2 * ETM_CIPHERTEXTBYTES) {
    printf("Server requested client authentication\n");
    ct_client_auth_len = ETM_CIPHERTEXTBYTES;
    if (!sk_client) {
      fprintf(stderr, "Client secret key is not ready\n");
      return 1;
    }
  } else {
    fprintf(stderr, "Server response is malformed\n");
    return 1;
  }

  // Process server response
  if (0 != etm_decap(ct_e, ss_e, sk_e)) {
    fprintf(stderr, "Client failed to decapsulate ephemeral secret\n");
    return 1;
  }
  if (ct_client_auth_len == ETM_CIPHERTEXTBYTES) {
    if (0 != etm_decap(ct_client_auth, ss_client_auth, sk_client)) {
      fprintf(stderr, "Client failed to decapsulate client authentication\n");
      return 1;
    } else {
      ss_client_auth_len = ETM_SESSIONKEYBYTES;
    }
  }

  // derive session key
  keccak_state state;
  shake256_init(&state);
  printf("Ephemeral shared secret: ");
  print_hexstr(ss_e, ETM_SESSIONKEYBYTES);
  shake256_absorb(&state, ss_e, ETM_SESSIONKEYBYTES);
  if (ss_server_auth_len == ETM_SESSIONKEYBYTES) {
    printf("Server authentication: ");
    print_hexstr(ss_server_auth, ETM_SESSIONKEYBYTES);
    shake256_absorb(&state, ss_e, ETM_SESSIONKEYBYTES);
  }
  if (ss_client_auth_len == ETM_SESSIONKEYBYTES) {
    printf("Client authentication: ");
    print_hexstr(ss_client_auth, ETM_SESSIONKEYBYTES);
    shake256_absorb(&state, ss_e, ETM_SESSIONKEYBYTES);
  }
  shake256_finalize(&state);
  shake256_squeeze(session_key, session_key_len, &state);

  return 0;
}
