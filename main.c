#include "authenticators.h"
#include "kyber/ref/indcpa.h"
#include "kyber/ref/params.h"
#include "kyber/ref/randombytes.h"
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
 * Generate the encrypt-then-MAC keypair using the pseudorandom coins as the
 * seed. Caller is responsible for providing correctly sized buffers.
 *
 * The ETM-KEM public key is identical to that of the PKE. The ETM-KEM private
 * key is laid out as kem_sk = pke_sk || pke_pk || SHA3-256(pke_pk) || z
 * where z is the rejection symbol.
 *
 * This function will never fail and so no return code is necessary
 */
static void etmkem_keypair_derand(uint8_t *pk, uint8_t *sk,
                                  const uint8_t *coins) {
  // location of various components
  uint8_t *indcpa_pk = pk;
  uint8_t *indcpa_sk = sk;
  uint8_t *indcpa_pk_in_sk = sk + KYBER_INDCPA_SECRETKEYBYTES;
  uint8_t *rejsymbol =
      sk + KYBER_INDCPA_SECRETKEYBYTES + KYBER_INDCPA_PUBLICKEYBYTES;
  indcpa_keypair_derand(indcpa_pk, indcpa_sk, coins);
  randombytes(rejsymbol, KYBER_INDCPA_MSGBYTES);
  memcpy(indcpa_pk_in_sk, indcpa_pk, KYBER_INDCPA_PUBLICKEYBYTES);
}

/**
 * The encrypt-then-MAC KEM encapsulates by encrypting a randomly sampled
 * PKE plaintext.
 */
static void etmkem_encap_derand(const uint8_t *pk, const uint8_t *coins) {
  // public key || PKE plaintext
  uint8_t pkpt[KYBER_INDCPA_PUBLICKEYBYTES + KYBER_INDCPA_MSGBYTES];
  // PKE ciphertext || MAC tag
  uint8_t cttag[KYBER_INDCPA_BYTES + POLY1305_TAGBYTES];
}

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

  etmkem_keypair_derand(etmkem_pk, etmkem_sk, coins);

  return 0;
}
