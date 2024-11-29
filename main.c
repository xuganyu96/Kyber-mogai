#include "kyber/ref/indcpa.h"
#include "kyber/ref/params.h"
#include "kyber/ref/randombytes.h"
#include <stdio.h>

int main(void) {
  uint8_t indcpa_pk[KYBER_INDCPA_PUBLICKEYBYTES];
  uint8_t indcpa_sk[KYBER_INDCPA_SECRETKEYBYTES];
  uint8_t indcpa_pt[KYBER_INDCPA_MSGBYTES];
  uint8_t decryption[KYBER_INDCPA_MSGBYTES];
  uint8_t indcpa_ct[KYBER_INDCPA_BYTES];
  uint8_t coins[KYBER_SYMBYTES];
  randombytes(coins, sizeof(coins));
  randombytes(indcpa_pt, sizeof(indcpa_pt));

  indcpa_keypair_derand(indcpa_pk, indcpa_sk, coins);
  indcpa_enc(indcpa_ct, indcpa_pt, indcpa_pk, coins);
  indcpa_dec(decryption, indcpa_ct, indcpa_sk);

  int diff = 0;
  for (int i = 0; i < sizeof(decryption); i++) {
    diff |= indcpa_pt[i] ^ decryption[i];
  }
  if (diff == 0) {
    printf("decryption successful\n");
  } else {
    printf("decryption failed\n");
  }

  return 0;
}
