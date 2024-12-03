#include "authenticators.h"
#include "kyber/ref/fips202.h"
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
 * PKE plaintext. The ciphertext and the shared secret will be written to the
 * input buffer. Caller is responsible for providing correctly sized buffer.
 */
static void etmkem_encap(uint8_t *ss, uint8_t *ct, const uint8_t *pk) {
  // INDCPA public key and plaintext will be absorbed together
  uint8_t pk_pt[KYBER_INDCPA_PUBLICKEYBYTES + KYBER_INDCPA_MSGBYTES];
  uint8_t *pt = pk_pt + KYBER_INDCPA_PUBLICKEYBYTES;
  memcpy(pk_pt, pk, KYBER_INDCPA_PUBLICKEYBYTES);
  randombytes(pt, KYBER_INDCPA_MSGBYTES);

  // hash public key and plaintext into:
  // prekey: which will later contribute to the session key
  // mackey: the symmetric key for the MAC
  // NOTE: some MAC has nonce (e.g. GMAC), which will need to be filled, as well
  // uint8_t prekey_mackey_macnonce[KYBER_SSBYTES + GMAC_KEYBYTES +
  //     GMAC_IVBYTES];
  uint8_t prekey_mackey[KYBER_SSBYTES + POLY1305_KEYBYTES];
  uint8_t *mackey = prekey_mackey + KYBER_SSBYTES;
  keccak_state xof;
  shake256_init(&xof);
  // NOTE: absorb_once is non-incremental whereas absorb is incremental; since
  // we have all absorption material, using absorb_once helps decreases the
  // number of function calls
  shake256_absorb_once(&xof, pk_pt,
                       KYBER_INDCPA_PUBLICKEYBYTES + KYBER_INDCPA_MSGBYTES);
  // NOTE: squeezeblocks will squeeze full blocks
  shake256_squeeze(prekey_mackey, KYBER_SSBYTES + POLY1305_KEYBYTES, &xof);

  // ETM-KEM's ciphertext contains the IND-CPA ciphertext and a MAC tag
  uint8_t coins[KYBER_SYMBYTES];
  randombytes(coins, KYBER_SYMBYTES);
  uint8_t *pke_ct = ct;
  uint8_t *mactag = ct + KYBER_INDCPA_BYTES;
  indcpa_enc(pke_ct, pt, pk, coins);
  mac_poly1305(mackey, pke_ct, KYBER_INDCPA_BYTES, mactag);

  // derive session key by hashing prekey (which already contains pk and pt) and
  // tag
  shake256_init(&xof);
  shake256_absorb(&xof, prekey_mackey, KYBER_SSBYTES); // absorb only the prekey
  shake256_absorb(&xof, mactag, POLY1305_TAGBYTES);
  shake256_finalize(&xof);
  shake256_squeeze(ss, KYBER_SSBYTES, &xof);
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
