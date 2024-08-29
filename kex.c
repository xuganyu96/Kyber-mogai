#include "kex.h"
#include "etm.h"
#include "kyber/ref/kem.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <unistd.h>

/**
 * Server receives client's public key, encapsulates, then transmits the
 * encapsulation to the client
 */
int server_handle_stream(int stream) {
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
int client_handle_stream(int stream) {
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
