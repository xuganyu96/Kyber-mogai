#include "easy-mceliece/mceliece348864/operations.h"
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

static size_t hamming_weight(uint8_t *bytes, size_t len) {
  size_t weight = 0;

  for (size_t i = 0; i < len; i++) {
    uint8_t byte = bytes[i];
    while (byte != 0) {
      weight++;
      byte &= byte - 1;
    }
  }

  return weight;
}

static int test_pke_correctness(void) {
  uint8_t pk[PKE_PUBLICKEYBYTES];
  uint8_t sk[PKE_SECRETKEYBYTES];
  uint8_t pt[PKE_PLAINTEXTBYTES];
  uint8_t ct[PKE_CIPHERTEXTBYTES];
  uint8_t coins[PKE_SYMBYTES];
  uint8_t decryption[PKE_PLAINTEXTBYTES];

  pke_keypair(pk, sk, coins);
  sample_pke_pt(pt, coins);
  if (hamming_weight(pt, PKE_PLAINTEXTBYTES) != SYS_T) {
    printf("Plaintext generation is wrong\n");
    return 1;
  } else {
    printf("Plaintext generatino is Ok\n");
  }
  pke_enc(ct, pt, pk, coins);
  pke_dec(decryption, ct, sk);

  int diff = 0;
  for (int i = 0; i < PKE_PLAINTEXTBYTES; i++) {
    diff |= pt[i] ^ decryption[i];
  }
  return diff;
}

int main(void) {
  if (test_pke_correctness()) {
    printf("fail\n");
  } else {
    printf("Ok\n");
  }

  return 0;
}
