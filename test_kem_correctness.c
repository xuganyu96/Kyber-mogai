#include "allkems.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define TEST_ROUNDS_LOG2 2

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
