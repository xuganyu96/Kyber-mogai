#include "allkems.h"
#include <arpa/inet.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define TEST_ROUNDS_LOG2 2

typedef struct kem_keypair_t {
  uint8_t pk[KEM_PUBLICKEYBYTES];
  uint8_t sk[KEM_SECRETKEYBYTES];
} kem_keypair_t;

static void write_clienthello(uint8_t *clienthello, uint8_t *ss_server_auth,
                              const uint8_t *pk_eph, const uint8_t *pk_server) {
  return;
}

/**
 * Perform a key exchange with the peer.
 *
 * If pk_server is provided, then server authentication is requested. If
 * keypair_client is provided, then client authenticastion is expected.
 */
static int kex_client(int sock, uint8_t *pk_server,
                      kem_keypair_t *keypair_client) {
  // TODO: regardless of the authentication mode, client and server should
  // exchange authentication keys before performing any key exchange! This way I
  // don't have to implement keypair encoding and/or decoding

  // key materials include (ss_eph || [ss_server] || [ss_client]), in this order
  uint8_t sesskey_material[KEM_BYTES + KEM_BYTES + KEM_BYTES];
  size_t sesskey_material_len = KEM_BYTES;
  if (pk_server)
    sesskey_material_len += KEM_BYTES;
  if (keypair_client)
    sesskey_material_len += KEM_BYTES;

  // ClientHello always include ephemeral public key and optionally includes
  // server authentication ciphertext
  uint8_t clienthello[KEM_PUBLICKEYBYTES + KEM_CIPHERTEXTBYTES];
  uint8_t ss_serverauth[KEM_BYTES];
  size_t clienthellolen = KEM_PUBLICKEYBYTES;
  if (pk_server)
    clienthellolen += KEM_CIPHERTEXTBYTES;

  kem_keypair_t keypair_eph;
  kem_keypair(keypair_eph.pk, keypair_eph.sk);
  write_clienthello(clienthello, ss_serverauth, keypair_eph.pk, pk_server);
  if (send(sock, clienthello, clienthellolen, 0) < 0) {
    fprintf(stderr, "Failed to send client hello\n");
    close(sock);
    exit(EXIT_FAILURE);
  }

  // ServerHello always includes ephemeral ciphertext and optionally includes
  // client authentication ciphertext
  uint8_t serverhello[KEM_CIPHERTEXTBYTES + KEM_CIPHERTEXTBYTES];
  ssize_t serverhello_len =
      recv(sock, serverhello, KEM_CIPHERTEXTBYTES + KEM_CIPHERTEXTBYTES, 0);
  if (serverhello_len < 0) {
    fprintf(stderr, "Failed to receive server hello\n");
    close(sock);
    exit(EXIT_FAILURE);
  } else if (serverhello_len == 0) {
    fprintf(stderr, "Server unexpectedly closed connection\n");
    close(sock);
    exit(EXIT_FAILURE);
  }

  close(sock);
  return 0;
}

int main(void) {
  uint8_t pk[KEM_PUBLICKEYBYTES];
  uint8_t sk[KEM_SECRETKEYBYTES];
  uint8_t ct[KEM_CIPHERTEXTBYTES];
  uint8_t ss[KEM_BYTES];
  uint8_t ss_cmp[KEM_BYTES];
  kem_keypair(pk, sk);

  int diff = 0;
  for (int i = 0; i < (1 << 2); i++) {
    kem_enc(ct, ss, pk);
    kem_dec(ss_cmp, ct, sk);

    for (int j = 0; j < KEM_BYTES; j++) {
      diff |= ss[j] ^ ss_cmp[j];
    }
  }

  if (diff) {
    fprintf(stderr, "Incorrect\n");
    exit(EXIT_FAILURE);
  } else {
    printf("Ok\n");
  }
  return 0;
}
