#include "etmkem.h"
#include "kyber/ref/randombytes.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define TEST_ROUNDS 1000

static int test_etmkem_correctness(void) {
  uint8_t pk[ETMKEM_PUBLICKEYBYTES];
  uint8_t sk[ETMKEM_SECRETKEYBYTES];
  uint8_t ct[ETMKEM_CIPHERTEXTBYTES];
  uint8_t ss[ETMKEM_SSBYTES];
  uint8_t ss_cmp[ETMKEM_SSBYTES];
  uint8_t coins[ETMKEM_SYMBYTES];
  randombytes(coins, ETMKEM_SYMBYTES);
  etmkem_keypair(pk, sk);

  int diff = 0;

  for (int i = 0; i < TEST_ROUNDS; i++) {
    etmkem_encap(ct, ss, pk);
    etmkem_decap(ss_cmp, ct, sk);
    for (int j = 0; j < ETMKEM_SSBYTES; j++) {
      diff |= ss[j] ^ ss_cmp[j];
    }
  }

  return diff;
}

int main(void) {
  int fail = 0;

  fail |= test_etmkem_correctness();

  if (fail) {
    fprintf(stderr, "Fail.\n");
    exit(EXIT_FAILURE);
  } else {
    printf("Ok\n");
  }

  return 0;
}
