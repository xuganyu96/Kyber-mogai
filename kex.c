#include "kex.h"
#include "etm.h"
#include "kyber/ref/fips202.h"
#include "utils.h"
#include <stdint.h>
#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>

int fread_exact(FILE *fd, uint8_t *data, size_t data_len) {
  size_t file_len = fread(data, data_len, 1, fd);
  return file_len - data_len;
}

int server_handle(int stream, uint8_t *sk_server, uint8_t *pk_client,
                  uint8_t *session_key, size_t session_key_len) {
  uint8_t prekey[3 * KEX_SESSION_KEY_BYTES];
  uint8_t client_tx[KEX_PUBLIC_KEY_BYTES + KEX_CIPHERTEXT_BYTES];
  uint8_t server_tx[2 * KEX_CIPHERTEXT_BYTES];
  uint8_t *ss_e = prekey; // length is unnecessary since ss_e is required
  uint8_t *ss_server_auth = prekey + KEX_SESSION_KEY_BYTES;
  size_t ss_server_auth_len = 0;
  uint8_t *ss_client_auth = prekey + KEX_SESSION_KEY_BYTES * 2;
  size_t ss_client_auth_len = 0;
  uint8_t *pk_e = client_tx;
  uint8_t *ct_server_auth = client_tx + KEX_PUBLIC_KEY_BYTES;
  size_t ct_server_auth_len = 0;
  uint8_t *ct_e = server_tx;
  uint8_t *ct_client_auth = server_tx + KEX_CIPHERTEXT_BYTES;
  size_t ct_client_auth_len = 0;

  printf("Waiting for client transmission...\n");
  size_t rx_len = read(stream, client_tx, sizeof(client_tx));
  if (rx_len == KEX_PUBLIC_KEY_BYTES) {
    printf("Client did not request server authentication\n");
  } else if (rx_len == KEX_PUBLIC_KEY_BYTES + KEX_CIPHERTEXT_BYTES) {
    printf("Client requested server authentication\n");
    if (!sk_server) {
      fprintf(stderr, "ERROR: Server secret key is not ready\n");
      return 1;
    }
    ct_server_auth_len = KEX_CIPHERTEXT_BYTES;
  } else {
    fprintf(stderr,
            "ERROR: Client transmission is malformed. Aborting key exchange\n");
    return 1;
  }
  // Process client transmission
  if (ct_server_auth_len == KEX_CIPHERTEXT_BYTES) {
    if (0 != kex_decap(ss_server_auth, ct_server_auth, sk_server)) {
      fprintf(stderr,
              "ERROR: server failed to decapsulate server authentication\n");
      return 1;
    } else {
      ss_server_auth_len = KEX_SESSION_KEY_BYTES;
    }
  }

  // construct server response
  if (0 != kex_encap(ct_e, ss_e, pk_e)) {
    fprintf(stderr, "ERROR: server failed to encapsulate ephemeral secret\n");
    return 1;
  }
  if (pk_client) {
    if (0 != kex_encap(ct_client_auth, ss_client_auth, pk_client)) {
      fprintf(stderr,
              "ERROR: server failed to encapsulate client authentication\n");
      return 1;
    } else {
      printf("Server requested client authentication\n");
      ss_client_auth_len = KEX_SESSION_KEY_BYTES;
      ct_client_auth_len = KEX_CIPHERTEXT_BYTES;
    }
  }
  // send server response
  size_t tx_len;
  if (ct_client_auth_len == KEX_CIPHERTEXT_BYTES) {
    tx_len = send(stream, server_tx, KEX_CIPHERTEXT_BYTES * 2, 0);
    if (tx_len != KEX_CIPHERTEXT_BYTES * 2) {
      fprintf(stderr, "ERROR: server failed to send response\n");
      return 1;
    }
  } else {
    tx_len = send(stream, server_tx, KEX_CIPHERTEXT_BYTES, 0);
    if (tx_len != KEX_CIPHERTEXT_BYTES) {
      fprintf(stderr, "ERROR: server failed to send response\n");
      return 1;
    }
  }

  // derive session key
  keccak_state state;
  shake256_init(&state);
  printf("Ephemeral shared secret: ");
  print_hexstr(ss_e, KEX_SESSION_KEY_BYTES);
  shake256_absorb(&state, ss_e, KEX_SESSION_KEY_BYTES);
  if (ss_server_auth_len == KEX_SESSION_KEY_BYTES) {
    printf("Server authentication: ");
    print_hexstr(ss_server_auth, KEX_SESSION_KEY_BYTES);
    shake256_absorb(&state, ss_server_auth, KEX_SESSION_KEY_BYTES);
  }
  if (ss_client_auth_len == KEX_SESSION_KEY_BYTES) {
    printf("Client authentication: ");
    print_hexstr(ss_client_auth, KEX_SESSION_KEY_BYTES);
    shake256_absorb(&state, ss_client_auth, KEX_SESSION_KEY_BYTES);
  }
  shake256_finalize(&state);
  shake256_squeeze(session_key, session_key_len, &state);
  return 0;
}

int client_handle(int stream, uint8_t *sk_client, uint8_t *pk_server,
                  uint8_t *session_key, size_t session_key_len) {
  uint8_t prekey[3 * KEX_SESSION_KEY_BYTES];
  uint8_t client_tx[KEX_PUBLIC_KEY_BYTES + KEX_CIPHERTEXT_BYTES];
  uint8_t server_tx[2 * KEX_CIPHERTEXT_BYTES];
  uint8_t *ss_e = prekey; // length is unnecessary since ss_e is required
  uint8_t *ss_server_auth = prekey + KEX_SESSION_KEY_BYTES;
  size_t ss_server_auth_len = 0;
  uint8_t *ss_client_auth = prekey + KEX_SESSION_KEY_BYTES * 2;
  size_t ss_client_auth_len = 0;
  uint8_t *pk_e = client_tx;
  uint8_t *ct_server_auth = client_tx + KEX_PUBLIC_KEY_BYTES;
  size_t ct_server_auth_len = 0;
  uint8_t *ct_e = server_tx;
  uint8_t *ct_client_auth = server_tx + KEX_CIPHERTEXT_BYTES;
  size_t ct_client_auth_len = 0;
  uint8_t sk_e[KEX_SECRET_KEY_BYTES];

  // Prepare client transmission
  kex_keygen(pk_e, sk_e);
  if (pk_server) {
    printf("Client requested server authentication\n");
    kex_encap(ct_server_auth, ss_server_auth, pk_server);
    ct_server_auth_len = KEX_CIPHERTEXT_BYTES;
    ss_server_auth_len = KEX_SESSION_KEY_BYTES;
  }

  // Send client transmission to server
  ssize_t expected_tx_len;
  if (ct_server_auth_len == 0) {
    expected_tx_len = KEX_PUBLIC_KEY_BYTES;
  } else {
    expected_tx_len = KEX_PUBLIC_KEY_BYTES + KEX_CIPHERTEXT_BYTES;
  }
  if (expected_tx_len != send(stream, client_tx, expected_tx_len, 0)) {
    fprintf(stderr, "Client failed to transmit %ld bytes\n", expected_tx_len);
    return 1;
  }

  // Receive server response
  size_t rx_len = read(stream, server_tx, sizeof(server_tx));
  if (rx_len == KEX_CIPHERTEXT_BYTES) {
    printf("Server did not request client authentication\n");
  } else if (rx_len == 2 * KEX_CIPHERTEXT_BYTES) {
    printf("Server requested client authentication\n");
    ct_client_auth_len = KEX_CIPHERTEXT_BYTES;
    if (!sk_client) {
      fprintf(stderr, "Client secret key is not ready\n");
      return 1;
    }
  } else {
    fprintf(stderr, "Server response is malformed\n");
    return 1;
  }

  // Process server response
  if (0 != kex_decap(ss_e, ct_e, sk_e)) {
    fprintf(stderr, "Client failed to decapsulate ephemeral secret\n");
    return 1;
  }
  if (ct_client_auth_len == KEX_CIPHERTEXT_BYTES) {
    if (0 != kex_decap(ss_client_auth, ct_client_auth, sk_client)) {
      fprintf(stderr, "Client failed to decapsulate client authentication\n");
      return 1;
    } else {
      ss_client_auth_len = KEX_SESSION_KEY_BYTES;
    }
  }

  // derive session key
  keccak_state state;
  shake256_init(&state);
  printf("Ephemeral shared secret: ");
  print_hexstr(ss_e, KEX_SESSION_KEY_BYTES);
  shake256_absorb(&state, ss_e, KEX_SESSION_KEY_BYTES);
  if (ss_server_auth_len == KEX_SESSION_KEY_BYTES) {
    printf("Server authentication: ");
    print_hexstr(ss_server_auth, KEX_SESSION_KEY_BYTES);
    shake256_absorb(&state, ss_server_auth, KEX_SESSION_KEY_BYTES);
  }
  if (ss_client_auth_len == KEX_SESSION_KEY_BYTES) {
    printf("Client authentication: ");
    print_hexstr(ss_client_auth, KEX_SESSION_KEY_BYTES);
    shake256_absorb(&state, ss_client_auth, KEX_SESSION_KEY_BYTES);
  }
  shake256_finalize(&state);
  shake256_squeeze(session_key, session_key_len, &state);

  return 0;
}
