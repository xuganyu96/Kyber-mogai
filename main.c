#include "pke.h"
#include <stdint.h>
#include <stdio.h>

static void println_hexstr(uint8_t *bytes, size_t len) {
  printf("0x");
  for (size_t i = 0; i < len; i++) {
    printf("%02X", bytes[i]);
  }
  printf("\n");
}

int main(void) {
  uint8_t pk[PKE_PUBLICKEYBYTES];
  uint8_t sk[PKE_SECRETKEYBYTES];
  uint8_t pt[PKE_PLAINTEXTBYTES];
  uint8_t ct[PKE_CIPHERTEXTBYTES];
  uint8_t coins[PKE_SYMBYTES];
  uint8_t decryption[PKE_PLAINTEXTBYTES];

  pke_keypair(pk, sk, coins);
  sample_pke_pt(pt, coins);
  printf("PKE plaintext: ");
  println_hexstr(pt, PKE_PLAINTEXTBYTES);

  pke_enc(ct, pt, pk, coins);
  printf("PKE ciphertext: ");
  println_hexstr(ct, PKE_CIPHERTEXTBYTES);

  pke_dec(decryption, ct, sk);
  printf("Decryption: ");
  println_hexstr(decryption, PKE_PLAINTEXTBYTES);

  int diff = 0;
  for (int i = 0; i < PKE_PLAINTEXTBYTES; i++) {
    diff |= pt[i] ^ decryption[i];
  }
  if (diff) {
    printf("fail\n");
  } else {
    printf("OK\n");
  }
  return 0;
}
