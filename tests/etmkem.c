#include "../etmkem.h"
#include "../authenticators.h"
#include "../kyber/ref/params.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int test_correctness(void) {
  uint8_t etmkem_pk[ETMKEM_PUBLICKEYBYTES];
  uint8_t etmkem_sk[ETMKEM_SECRETKEYBYTES];
  uint8_t coins[ETMKEM_SYMBYTES];
  for (int i = 0; i < ETMKEM_SYMBYTES; i++)
    coins[i] = 0;

  uint8_t etmkem_ct[ETMKEM_CIPHERTEXTBYTES];
  uint8_t etmkem_ss1[ETMKEM_SSBYTES];
  uint8_t etmkem_ss2[ETMKEM_SSBYTES];
  etmkem_keypair_derand(etmkem_pk, etmkem_sk, coins);
  etmkem_encap(etmkem_ct, etmkem_ss1, etmkem_pk);
  etmkem_decap(etmkem_ss2, etmkem_ct, etmkem_sk);

  int diff = 0;

  for (int i = 0; i < KYBER_SSBYTES; i++) {
    diff |= etmkem_ss1[i] ^ etmkem_ss2[i];
  }

  return diff;
}

int main(void) {
  int fail = 0;
  fail |= test_correctness();

  if (fail) {
    fprintf(stderr, "test failed...\n");
    exit(fail);
  } else {
    printf("Ok\n");
  }

  return fail;
}
