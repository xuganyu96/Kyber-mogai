#if defined(PKE_KYBER)
#include "kyber/ref/randombytes.h"
#elif defined(PKE_MCELIECE)
#include "easy-mceliece/ref/randombytes.h"
#endif
#include "pke.h"
#include <stdio.h>
#include <stdlib.h>

#define TEST_ROUNDS 10

/**
 * For random keypair and random message, decryption should be correct
 */
static int test_pke_correctness(void) {
  uint8_t pk[PKE_PUBLICKEYBYTES];
  uint8_t sk[PKE_SECRETKEYBYTES];
  uint8_t pt[PKE_PLAINTEXTBYTES];
  uint8_t ct[PKE_CIPHERTEXTBYTES];
  uint8_t pt_cmp[PKE_PLAINTEXTBYTES];
  uint8_t coins[PKE_SYMBYTES];
  int diff = 0;
  randombytes(coins, PKE_SYMBYTES);
  pke_keypair(pk, sk, coins);

  for (int i = 0; i < TEST_ROUNDS; i++) {
    randombytes(coins, PKE_SYMBYTES);
    sample_pke_pt(pt, coins);
    randombytes(coins, PKE_SYMBYTES);
    pke_enc(ct, pt, pk, coins);
    pke_dec(pt_cmp, ct, sk);

    for (int j = 0; j < PKE_PLAINTEXTBYTES; j++) {
      diff |= pt[j] ^ pt_cmp[j];
    }
  }

  return diff;
}

int main(void) {
  int fail = 0;

  fail |= test_pke_correctness();

  if (fail) {
    fprintf(stderr, "Failed\n");
    exit(EXIT_FAILURE);
  } else {
    printf("Ok\n");
  }
  return 0;
}
