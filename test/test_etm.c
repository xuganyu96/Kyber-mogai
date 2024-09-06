#include "../authenticators.h"
#include "../etm.h"
#include "../kyber/ref/kem.h"
#include "../kyber/ref/params.h"
#include "stdio.h"

#define ROUNDS 10000

static int randomized_encap_then_decap(void) {
  uint8_t pk[ETM_PUBLICKEYBYTES];
  uint8_t sk[ETM_SECRETKEYBYTES];
  uint8_t ct[ETM_CIPHERTEXTBYTES];
  uint8_t ss[ETM_SESSIONKEYBYTES];
  uint8_t decapsulation[ETM_SESSIONKEYBYTES];
  crypto_kem_keypair(pk, sk);
  for (int round = 0; round < ROUNDS; round++) {
    etm_encap(ct, ss, pk);
    etm_decap(ct, decapsulation, sk);
    for (size_t i = 0; i < ETM_SESSIONKEYBYTES; i++) {
      if (ss[i] != decapsulation[i]) {
        fprintf(stderr, "Decapsulation failed\n");
        return 1;
      }
    }
  }

  return 0;
}

int main(void) {
  int fail = 0;

  fail |= randomized_encap_then_decap();

  if (fail) {
    return 1;
  }

  printf("Ok\n");
  return 0;
}
