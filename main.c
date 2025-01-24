/**
* Jan 24, 2025: I have this terrible idea of just implementing everything in a
* single file. Authenticators will still be a separate set of files, as will the
* mceliece implementations, but correctness/speed tests and encrypt-then-MAC KEM's
* will all be in this single file
*/
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "easy-mceliece.h"

static void println_hexstr(uint8_t *bytes, size_t arrlen) {
  printf("0x");
  for (size_t i = 0; i < arrlen; i++) {
    printf("%02X", bytes[i]);
  }
  printf("\n");
}

int main(void) {
  uint8_t pk[CRYPTO_PUBLICKEYBYTES];
  uint8_t sk[CRYPTO_SECRETKEYBYTES];
  uint8_t errvec[CRYPTO_PLAINTEXTBYTES];
  uint8_t ct[CRYPTO_CIPHERTEXTBYTES];

  crypto_kem_keypair(pk, sk);
  println_hexstr(pk, CRYPTO_PUBLICKEYBYTES);
  println_hexstr(sk, CRYPTO_SECRETKEYBYTES);

  exit(EXIT_SUCCESS);
}
