#include "easy-mceliece/mceliece348864/benes.h"
#include "easy-mceliece/mceliece348864/bm.h"
#include "easy-mceliece/mceliece348864/crypto_kem.h"
#include "easy-mceliece/mceliece348864/encrypt.h"
#include "easy-mceliece/mceliece348864/gf.h"
#include "easy-mceliece/mceliece348864/params.h"
#include "easy-mceliece/mceliece348864/root.h"
#include "easy-mceliece/mceliece348864/synd.h"
#include "easy-mceliece/mceliece348864/util.h"
#include "pke.h"

/**
 * Generate mceliece348864 keypair
 *
 * Classic McEliece's reference implementation does not have a dedicated
 * `indcpa_keypair` routine like Kyber, so we directly use the KEM key
 * generation routine. The performance difference is irrelevant because we don't
 * care about key generation performance within the scope of this paper.
 * However, **the KEM key generation adds some pseudorandom seed bytes to the
 * secret key, so in decryption we need to add the correct offset**
 *
 * TODO: for now the coins will be ignored because classic McEliece's reference
 * implementation does not have a "derand" key generation routine.
 */
void pke_keypair(uint8_t *pke_pk, uint8_t *pke_sk, const uint8_t *coins) {
  crypto_kem_keypair(pke_pk, pke_sk);
}

/**
 * Sample a random McEliece plaintext.
 */
void sample_pke_pt(uint8_t *pke_pt, const uint8_t *coins) { gen_e(pke_pt); }

/**
 * Encrypt the given plaintext using the given public key
 */
void pke_enc(uint8_t *pke_ct, const uint8_t *pke_pt, const uint8_t *pke_pk,
             const uint8_t *coins) {
  syndrome(pke_ct, pke_pk, pke_pt);
}

/**
 * Decrypt the ciphertext
 *
 * This implementation is taken from decrypt.c in the reference McEliece
 * impl, but the re-encryption step is removed because we will check ciphertext
 * integrity using encrypt-then-MAC
 */
void pke_dec(uint8_t *pke_pt, const uint8_t *pke_ct, const uint8_t *pke_sk) {
  pke_sk += 40; // TODO: 40-bytes include seed and rejection symbol, prbly

  int i = 0;
  unsigned char r[SYS_N / 8];
  gf g[SYS_T + 1];
  gf L[SYS_N];
  gf s[SYS_T * 2];
  gf locator[SYS_T + 1];
  gf images[SYS_N];
  gf t;

  for (i = 0; i < SYND_BYTES; i++)
    r[i] = pke_ct[i];
  for (i = SYND_BYTES; i < SYS_N / 8; i++)
    r[i] = 0;

  for (i = 0; i < SYS_T; i++) {
    g[i] = load_gf(pke_sk);
    pke_sk += 2;
  }
  g[SYS_T] = 1;

  support_gen(L, pke_sk);
  synd(s, g, L, r);
  bm(locator, s);
  root(images, locator, L);

  for (i = 0; i < SYS_N / 8; i++)
    pke_pt[i] = 0;

  for (i = 0; i < SYS_N; i++) {
    t = gf_iszero(images[i]) & 1;

    pke_pt[i / 8] |= t << (i % 8);
  }
}
