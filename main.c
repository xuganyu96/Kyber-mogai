#include "authenticators.h"
#include "etmkem.h"
#include "kyber/ref/params.h"
#include <stdio.h>
#include <string.h>

// KEM public key will be identical to that of the PKE public key
#define ETMKEM_PUBLICKEYBYTES KYBER_INDCPA_PUBLICKEYBYTES
// KEM secret key will include PKE secret key, PKE public key (for hashing into
// MAC key), and the implicit rejection symbol
#define ETMKEM_SECRETKEYBYTES                                                  \
  (KYBER_INDCPA_SECRETKEYBYTES + KYBER_INDCPA_PUBLICKEYBYTES +                 \
   KYBER_INDCPA_MSGBYTES)
// The size of seed
#define ETMKEM_SYMBYTES KYBER_SYMBYTES
// Size of shared secret
#define ETMKEM_SSBYTES

/**
 * print the input bytes as hexadecimal string, then print a new line
 */
static void println_hexstr(uint8_t *bytes, size_t len) {
  printf("0x");
  for (size_t i = 0; i < len; i++) {
    printf("%02X", bytes[i]);
  }
  printf("\n");
}

int main(void) {
  uint8_t etmkem_pk[ETMKEM_PUBLICKEYBYTES];
  uint8_t etmkem_sk[ETMKEM_SECRETKEYBYTES];
  uint8_t coins[ETMKEM_SYMBYTES];
  for (int i = 0; i < ETMKEM_SYMBYTES; i++)
    coins[i] = 0;

  uint8_t etmkem_ct[KYBER_INDCPA_BYTES + POLY1305_TAGBYTES];
  uint8_t etmkem_ss1[KYBER_SSBYTES];
  uint8_t etmkem_ss2[KYBER_SSBYTES];
  etmkem_keypair_derand(etmkem_pk, etmkem_sk, coins);
  etmkem_encap(etmkem_ct, etmkem_ss1, etmkem_pk);
  etmkem_decap(etmkem_ss2, etmkem_ct, etmkem_sk);

  printf("encapsulation: ");
  println_hexstr(etmkem_ss1, KYBER_SSBYTES);
  printf("decapsulation: ");
  println_hexstr(etmkem_ss2, KYBER_SSBYTES);

  printf("tempered with ciphertext\n");
  etmkem_ct[0] = 0;
  etmkem_decap(etmkem_ss2, etmkem_ct, etmkem_sk);
  printf("encapsulation: ");
  println_hexstr(etmkem_ss1, KYBER_SSBYTES);
  printf("decapsulation: ");
  println_hexstr(etmkem_ss2, KYBER_SSBYTES);
  return 0;
}
