#include "pke.h"

#if defined(PKE_KYBER)
/**
 * The PKE subroutines of Kyber
 */
#include "kyber/ref/indcpa.h"
#include "kyber/ref/params.h"
#include "kyber/ref/randombytes.h"

void pke_keypair(uint8_t *pke_pk, uint8_t *pke_sk, const uint8_t *coins) {
  indcpa_keypair_derand(pke_pk, pke_sk, coins);
}

void sample_pke_pt(uint8_t *pke_pt, const uint8_t *_) {
  randombytes(pke_pt, KYBER_INDCPA_MSGBYTES);
}

void pke_enc(uint8_t *pke_ct, const uint8_t *pke_pt, const uint8_t *pke_pk,
             const uint8_t *coins) {
  indcpa_enc(pke_ct, pke_pt, pke_pk, coins);
}

void pke_dec(uint8_t *pke_pt, const uint8_t *pke_ct, const uint8_t *pke_sk) {
  indcpa_dec(pke_pt, pke_ct, pke_sk);
}

#elif defined(PKE_MCELIECE)
#include "easy-mceliece/vec/crypto_kem.h"
#include "easy-mceliece/vec/decrypt.h"
#include "easy-mceliece/vec/encrypt.h"

void pke_keypair(uint8_t *pke_pk, uint8_t *pke_sk, const uint8_t *coins) {
  crypto_kem_keypair(pke_pk, pke_sk);
}

void sample_pke_pt(uint8_t *pke_pt, const uint8_t *coins) { gen_e(pke_pt); }

void pke_enc(uint8_t *pke_ct, const uint8_t *pke_pt, const uint8_t *pke_pk,
             const uint8_t *coins) {
  syndrome(pke_ct, pke_pk, pke_pt);
}

void pke_dec(uint8_t *pke_pt, const uint8_t *pke_ct, const uint8_t *pke_sk) {
  pke_sk += 40;
  cpa_decrypt(pke_pt, pke_sk, pke_ct);
}

#else
#error "Must define one of PKE_KYBER or PKE_MCELIECE"
#endif
