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
#include "easy-mceliece/avx/mceliece348864/decrypt.h"
#include "easy-mceliece/avx/mceliece348864/encrypt.h"

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
  uint8_t pt[CRYPTO_PLAINTEXTBYTES];
  uint8_t pt_cmp[CRYPTO_PLAINTEXTBYTES];
  uint8_t ct[CRYPTO_CIPHERTEXTBYTES];

  crypto_kem_keypair(pk, sk);
  println_hexstr(pk, CRYPTO_PUBLICKEYBYTES);
  println_hexstr(sk, CRYPTO_SECRETKEYBYTES);

  gen_e(pt);
  println_hexstr(pt, CRYPTO_PLAINTEXTBYTES);

  syndrome(ct, pk, pt);
  println_hexstr(ct, CRYPTO_CIPHERTEXTBYTES);

  cpa_decrypt(pt_cmp, sk, ct);
  uint8_t diff = 0;
  for (int i = 0; i < CRYPTO_PLAINTEXTBYTES; i++) {
    diff |= pt[i] ^ pt_cmp[i];
  }
  if (diff) {
    printf("CPA decryption failed\n");
    exit(EXIT_FAILURE);
  }

  exit(EXIT_SUCCESS);
}
