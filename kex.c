#include "kex.h"
#include "etm.h"
#include "kyber/ref/fips202.h"
#include "kyber/ref/kem.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <unistd.h>

/**
 * Read exactly data_len bytes from fd. Return 0 on success
 */
int fread_exact(FILE *fd, uint8_t *data, size_t data_len) {
  size_t file_len = fread(data, data_len, 1, fd);
  return file_len - data_len;
}

/**
 * Server receives client's public key, encapsulates, then transmits the
 * encapsulation to the client
 */
int kex_server(int stream) {
  uint8_t pk_client[ETM_PUBLICKEYBYTES] = {0};
  uint8_t ct_e[ETM_CIPHERTEXTBYTES] = {0};
  uint8_t ss_e[ETM_SESSIONKEYBYTES] = {0};

  fprintf(stderr, "Waiting for client public key...\n");
  ssize_t rx_len = 0;
  rx_len = read(stream, pk_client, ETM_PUBLICKEYBYTES);
  if (rx_len != ETM_PUBLICKEYBYTES) {
    fprintf(stderr,
            "Client public key is malformed; expected %d bytes, received %ld "
            "bytes\n",
            ETM_PUBLICKEYBYTES, rx_len);
    return 1;
  } else {
    printf("Received client public key\n");
  }

  if (etm_encap(ct_e, ss_e, pk_client) != 0) {
    fprintf(stderr, "Server failed to encapsulate");
    return 1;
  } else {
    printf("Server successfully encapsulated\n");
  }

  ssize_t tx_len = send(stream, ct_e, ETM_CIPHERTEXTBYTES, 0);
  if (tx_len != ETM_CIPHERTEXTBYTES) {
    fprintf(stderr, "Server failed to send ciphertext\n");
    return 1;
  } else {
    printf("Session key: 0x");
    for (size_t i = 0; i < ETM_SESSIONKEYBYTES; i++) {
      printf("%02X", ss_e[i]);
    }
    printf("\n");
  }

  return 0;
}

/**
 * Client generates keypair and transmits the public key, then receives
 * ciphertext and decapsulates
 */
int kex_client(int stream) {
  uint8_t pk_client[ETM_PUBLICKEYBYTES];
  uint8_t sk_client[ETM_SECRETKEYBYTES];
  uint8_t ct_e[ETM_CIPHERTEXTBYTES];
  uint8_t ss_e[ETM_SESSIONKEYBYTES];

  if (crypto_kem_keypair(pk_client, sk_client) != 0) {
    fprintf(stderr, "Key generation failed");
    return 1;
  } else {
    printf("Client generated keypair\n");
  }

  ssize_t tx_len = send(stream, pk_client, ETM_PUBLICKEYBYTES, 0);
  if (tx_len != ETM_PUBLICKEYBYTES) {
    fprintf(stderr, "Failed to send ciphertext\n");
    return 1;
  } else {
    printf("%ld bytes of public key transmitted\n", tx_len);
  }

  ssize_t rx_len = read(stream, ct_e, ETM_CIPHERTEXTBYTES);
  if (rx_len != ETM_CIPHERTEXTBYTES) {
    fprintf(stderr,
            "Server's encapsulation is malformed: expected %d bytes, found %ld "
            "bytes\n",
            ETM_CIPHERTEXTBYTES, rx_len);
  } else {
    printf("Received %ld bytes of ciphertext\n", rx_len);
  }

  if (etm_decap(ct_e, ss_e, sk_client) != 0) {
    fprintf(stderr, "Client failed to decapsulate\n");
    return 1;
  } else {
    printf("Session key: 0x");
    for (size_t i = 0; i < ETM_SESSIONKEYBYTES; i++) {
      printf("%02X", ss_e[i]);
    }
    printf("\n");
  }

  return 0;
}

int uakex_server(int stream, uint8_t *server_sk) {
  uint8_t client_tx[ETM_CIPHERTEXTBYTES + ETM_PUBLICKEYBYTES] = {0};
  uint8_t *pk_client = client_tx + ETM_CIPHERTEXTBYTES;
  uint8_t *ct_auth = client_tx;
  uint8_t ss_e_auth[2 * ETM_SESSIONKEYBYTES] = {0};
  uint8_t *ss_e = ss_e_auth;
  uint8_t *ss_auth = ss_e_auth + ETM_SESSIONKEYBYTES;
  uint8_t ct_e[ETM_CIPHERTEXTBYTES] = {0};

  fprintf(stderr, "Waiting for client transmission...\n");
  ssize_t rx_len = 0;
  rx_len = read(stream, client_tx, ETM_CIPHERTEXTBYTES + ETM_PUBLICKEYBYTES);
  if (rx_len != ETM_CIPHERTEXTBYTES + ETM_PUBLICKEYBYTES) {
    fprintf(stderr,
            "Client public key is malformed; expected %d bytes, received %ld "
            "bytes\n",
            ETM_CIPHERTEXTBYTES + ETM_PUBLICKEYBYTES, rx_len);
    return 1;
  } else {
    printf("Received client public key\n");
  }

  // Decapsulate the authentication session key
  etm_decap(ct_auth, ss_auth, server_sk);

  if (etm_encap(ct_e, ss_e, pk_client) != 0) {
    fprintf(stderr, "Server failed to encapsulate");
    return 1;
  } else {
    printf("Server successfully encapsulated\n");
  }

  ssize_t tx_len = send(stream, ct_e, ETM_CIPHERTEXTBYTES, 0);
  if (tx_len != ETM_CIPHERTEXTBYTES) {
    fprintf(stderr, "Server failed to send ciphertext\n");
    return 1;
  } else {
    printf("Server transmitted %ld bytes of ciphertext\n", tx_len);
  }

  uint8_t session_key[ETM_SESSIONKEYBYTES];
  sha3_256(session_key, ss_e_auth, sizeof(ss_e_auth));
  printf("Server authentication session key: 0x");
  for (size_t i = 0; i < ETM_SESSIONKEYBYTES; i++) {
    printf("%02X", ss_auth[i]);
  }
  printf("\n");
  printf("Ephemeral session key: 0x");
  for (size_t i = 0; i < ETM_SESSIONKEYBYTES; i++) {
    printf("%02X", ss_e[i]);
  }
  printf("\n");
  printf("Session key: 0x");
  for (size_t i = 0; i < ETM_SESSIONKEYBYTES; i++) {
    printf("%02X", session_key[i]);
  }
  printf("\n");

  return 0;
}

int uakex_client(int stream, const uint8_t *server_pk) {
  uint8_t client_tx[ETM_CIPHERTEXTBYTES + ETM_PUBLICKEYBYTES];
  uint8_t *ct_auth = client_tx;
  uint8_t *pk_e = client_tx + ETM_CIPHERTEXTBYTES;
  uint8_t ss_e_auth[2 * ETM_SESSIONKEYBYTES];
  uint8_t *ss_e = ss_e_auth;
  uint8_t *ss_auth = ss_e_auth + ETM_SESSIONKEYBYTES;
  uint8_t sk_e[ETM_SECRETKEYBYTES];
  uint8_t ct_e[ETM_CIPHERTEXTBYTES];

  crypto_kem_keypair(pk_e, sk_e);
  etm_encap(ct_auth, ss_auth, server_pk);
  ssize_t tx_len =
      send(stream, client_tx, ETM_CIPHERTEXTBYTES + ETM_PUBLICKEYBYTES, 0);
  if (tx_len != ETM_CIPHERTEXTBYTES + ETM_PUBLICKEYBYTES) {
    fprintf(stderr, "Client failed to transmit ciphertext and public key\n");
    return 1;
  } else {
    printf("Client transmitted %ld bytes of ciphertext and public key\n",
           tx_len);
  }

  printf("Waiting for server's response...\n");
  ssize_t rx_len = read(stream, ct_e, ETM_CIPHERTEXTBYTES);
  if (rx_len != ETM_CIPHERTEXTBYTES) {
    fprintf(
        stderr,
        "Server response malformed: expected %d bytes, received %ld bytes\n",
        ETM_CIPHERTEXTBYTES, rx_len);
    return 1;
  } else {
    printf("Received server's response\n");
  }

  etm_decap(ct_e, ss_e, sk_e);
  uint8_t session_key[ETM_SESSIONKEYBYTES];
  sha3_256(session_key, ss_e_auth, sizeof(ss_e_auth));
  printf("Server authentication session key: 0x");
  for (size_t i = 0; i < ETM_SESSIONKEYBYTES; i++) {
    printf("%02X", ss_auth[i]);
  }
  printf("\n");
  printf("Ephemeral session key: 0x");
  for (size_t i = 0; i < ETM_SESSIONKEYBYTES; i++) {
    printf("%02X", ss_e[i]);
  }
  printf("\n");
  printf("Session key: 0x");
  for (size_t i = 0; i < ETM_SESSIONKEYBYTES; i++) {
    printf("%02X", session_key[i]);
  }
  printf("\n");

  return 0;
}
