#include "etmkem.h"
#include "authenticators.h"
#if defined(PKE_KYBER)
#include "kyber/ref/fips202.h"
#include "kyber/ref/randombytes.h"

#elif defined(PKE_MCELIECE)
#include "easy-mceliece/vec/keccak.h"
#include "easy-mceliece/vec/randombytes.h"

#else
#error "Must define PKE_KYBER or PKE_MCELIECE"
#endif
#include "pke.h"
#include <string.h>

/**
 * ETM-KEM key generation
 *
 * ETM-KEM public key is identical to the PKE public key. ETM-KEM secret key
 * contains three components:
 * (PKE secret key || Hash of PKE public key || rejection symbol)
 */
void etmkem_keypair(uint8_t *pk, uint8_t *sk) {
  uint8_t coins[PKE_SYMBYTES];
  randombytes(coins, PKE_SYMBYTES);
  pke_keypair(pk, sk, coins);

  shake256(sk + PKE_SECRETKEYBYTES, PKE_SYMBYTES, pk, PKE_PUBLICKEYBYTES);
#ifdef PREHASH_PUBLICKEY
  memcpy(pk + PKE_PUBLICKEYBYTES, sk + PKE_SECRETKEYBYTES, PKE_SYMBYTES);
#endif

  // rejection symbol should be independently sampled from PKE key pair
  randombytes(coins, PKE_SYMBYTES);
  sample_pke_pt(sk + PKE_SECRETKEYBYTES + PKE_SYMBYTES, coins);
}

/**
 * Encapsulate a random secret.
 */
void etmkem_encap(uint8_t *ct, uint8_t *ss, const uint8_t *pk) {
  // PKE public key hash and PKE plaintext is placed together so they can be
  // absorbed in a single Shake256 call
  uint8_t coins[PKE_SYMBYTES];
  randombytes(coins, PKE_SYMBYTES);
  uint8_t pkhash_pt[PKE_SYMBYTES + PKE_PLAINTEXTBYTES];
  sample_pke_pt(pkhash_pt + PKE_SYMBYTES, coins);
#ifdef PREHASH_PUBLICKEY
  memcpy(pkhash_pt, pk + PKE_PUBLICKEYBYTES, PKE_SYMBYTES);
#else
  shake256(pkhash_pt, PKE_SYMBYTES, pk, PKE_PUBLICKEYBYTES);
#endif

  // Hash (PKE public key hash || PKE plaintext) into the following:
  // (preKey || MAC key || MAC IV)
  uint8_t prekey_mackey_maciv[ETMKEM_SSBYTES + MAC_KEYBYTES + MAC_IVBYTES];
  shake256(prekey_mackey_maciv, ETMKEM_SSBYTES + MAC_KEYBYTES + MAC_IVBYTES,
           pkhash_pt, PKE_SYMBYTES + PKE_PLAINTEXTBYTES);

  // Compute the PKE ciphertext. Pseudorandomness need to be freshly sampled
  randombytes(coins, PKE_SYMBYTES);
  pke_enc(ct, pkhash_pt + PKE_SYMBYTES, pk, coins);
  mac_sign(ct + PKE_CIPHERTEXTBYTES, prekey_mackey_maciv + ETMKEM_SSBYTES,
           prekey_mackey_maciv + ETMKEM_SSBYTES + MAC_KEYBYTES, ct,
           PKE_CIPHERTEXTBYTES);

  // derive the shared secret
  uint8_t prekey_mactag[ETMKEM_SSBYTES + MAC_TAGBYTES];
  memcpy(prekey_mactag, prekey_mackey_maciv, ETMKEM_SSBYTES);
  memcpy(prekey_mactag + ETMKEM_SSBYTES, ct + PKE_CIPHERTEXTBYTES,
         MAC_TAGBYTES);
  shake256(ss, ETMKEM_SSBYTES, prekey_mactag, ETMKEM_SSBYTES + MAC_TAGBYTES);
}

/**
 * Decapsulate the random secret
 */
void etmkem_decap(uint8_t *ss, const uint8_t *ct, const uint8_t *sk) {
  uint8_t pkhash_pt[PKE_SYMBYTES + PKE_PLAINTEXTBYTES];
  memcpy(pkhash_pt, sk + PKE_SECRETKEYBYTES, PKE_SYMBYTES);
  pke_dec(pkhash_pt + PKE_SYMBYTES, ct, sk);

  // Hash (PKE public key hash || PKE plaintext) into the following:
  // (preKey || MAC key || MAC IV)
  uint8_t prekey_mackey_maciv[ETMKEM_SSBYTES + MAC_KEYBYTES + MAC_IVBYTES];
  shake256(prekey_mackey_maciv, ETMKEM_SSBYTES + MAC_KEYBYTES + MAC_IVBYTES,
           pkhash_pt, PKE_SYMBYTES + PKE_PLAINTEXTBYTES);

  // To achieve constant-time operation, both the true and the false shared
  // secret need to be computed
  uint8_t true_ss[ETMKEM_SSBYTES];
  uint8_t prekey_mactag[ETMKEM_SSBYTES + MAC_TAGBYTES];
  memcpy(prekey_mactag, prekey_mackey_maciv, ETMKEM_SSBYTES);
  memcpy(prekey_mactag + ETMKEM_SSBYTES, ct + PKE_CIPHERTEXTBYTES,
         MAC_TAGBYTES);
  shake256(true_ss, ETMKEM_SSBYTES, prekey_mactag,
           ETMKEM_SSBYTES + MAC_TAGBYTES);
  uint8_t false_ss[ETMKEM_SSBYTES];
  uint8_t rejection_ct[PKE_PLAINTEXTBYTES + PKE_CIPHERTEXTBYTES + MAC_TAGBYTES];
  memcpy(rejection_ct, sk + PKE_SECRETKEYBYTES + PKE_SYMBYTES,
         PKE_PLAINTEXTBYTES);
  memcpy(rejection_ct, ct, ETMKEM_CIPHERTEXTBYTES);
  shake256(false_ss, ETMKEM_SSBYTES, rejection_ct,
           PKE_PLAINTEXTBYTES + PKE_CIPHERTEXTBYTES + MAC_TAGBYTES);

  if (mac_cmp(ct + PKE_CIPHERTEXTBYTES, prekey_mackey_maciv + ETMKEM_SSBYTES,
              prekey_mackey_maciv + ETMKEM_SSBYTES + MAC_KEYBYTES, ct,
              PKE_CIPHERTEXTBYTES)) {
    memcpy(ss, false_ss, ETMKEM_SSBYTES);
  } else {
    memcpy(ss, true_ss, ETMKEM_SSBYTES);
  }
}
