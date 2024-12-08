#include "pke.h"
#include "speed.h"
#include <stdint.h>
#include <stdio.h>

#define TEST_ROUNDS_LOG2 2

int main(void) {
  uint8_t pk[PKE_PUBLICKEYBYTES];
  uint8_t sk[PKE_PUBLICKEYBYTES];
  uint8_t pt[PKE_PLAINTEXTBYTES];
  uint8_t ct[PKE_CIPHERTEXTBYTES];
  uint8_t coins[PKE_SYMBYTES];

  pke_keypair(pk, sk, coins);
  sample_pke_pt(pt, coins);
  pke_enc(ct, pt, pk, coins);

  uint64_t start = get_clock_cpu();
  for (int i = 0; i < (1 << TEST_ROUNDS_LOG2); i++)
    pke_dec(pt, ct, sk);
  uint64_t dur = get_clock_cpu() - start;
  dur >>= TEST_ROUNDS_LOG2;

  printf("PKE decrypt time: %llu\n", dur);

  return 0;
}
