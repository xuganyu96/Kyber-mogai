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

#elif defined(PKE_MCELIECE348864)
#include "easy-mceliece/mceliece348864/benes.h"
#include "easy-mceliece/mceliece348864/bm.h"
#include "easy-mceliece/mceliece348864/crypto_kem.h"
#include "easy-mceliece/mceliece348864/encrypt.h"
#include "easy-mceliece/mceliece348864/gf.h"
#include "easy-mceliece/mceliece348864/params.h"
#include "easy-mceliece/mceliece348864/root.h"
#include "easy-mceliece/mceliece348864/synd.h"
#include "easy-mceliece/mceliece348864/util.h"

void pke_keypair(uint8_t *pke_pk, uint8_t *pke_sk, const uint8_t *coins) {
  crypto_kem_keypair(pke_pk, pke_sk);
}

void sample_pke_pt(uint8_t *pke_pt, const uint8_t *coins) { gen_e(pke_pt); }

void pke_enc(uint8_t *pke_ct, const uint8_t *pke_pt, const uint8_t *pke_pk,
             const uint8_t *coins) {
  syndrome(pke_ct, pke_pk, pke_pt);
}

void pke_dec(uint8_t *pke_pt, const uint8_t *pke_ct, const uint8_t *pke_sk) {
  // NOTE: all levels of McEliece prepends 40-bytes of pseudorandom seed to
  // secret key, see crypto_kem_dec in operations.c
  pke_sk += 40;

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

#elif defined(PKE_MCELIECE460896)
#include "easy-mceliece/mceliece460896/benes.h"
#include "easy-mceliece/mceliece460896/bm.h"
#include "easy-mceliece/mceliece460896/crypto_kem.h"
#include "easy-mceliece/mceliece460896/encrypt.h"
#include "easy-mceliece/mceliece460896/gf.h"
#include "easy-mceliece/mceliece460896/params.h"
#include "easy-mceliece/mceliece460896/root.h"
#include "easy-mceliece/mceliece460896/synd.h"
#include "easy-mceliece/mceliece460896/util.h"

void pke_keypair(uint8_t *pke_pk, uint8_t *pke_sk, const uint8_t *coins) {
  crypto_kem_keypair(pke_pk, pke_sk);
}

void sample_pke_pt(uint8_t *pke_pt, const uint8_t *coins) { gen_e(pke_pt); }

void pke_enc(uint8_t *pke_ct, const uint8_t *pke_pt, const uint8_t *pke_pk,
             const uint8_t *coins) {
  syndrome(pke_ct, pke_pk, pke_pt);
}

void pke_dec(uint8_t *pke_pt, const uint8_t *pke_ct, const uint8_t *pke_sk) {
  // NOTE: all levels of McEliece prepends 40-bytes of pseudorandom seed to
  // secret key, see crypto_kem_dec in operations.c
  pke_sk += 40;

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

#elif defined(PKE_MCELIECE6688128)
#include "easy-mceliece/mceliece6688128/benes.h"
#include "easy-mceliece/mceliece6688128/bm.h"
#include "easy-mceliece/mceliece6688128/crypto_kem.h"
#include "easy-mceliece/mceliece6688128/encrypt.h"
#include "easy-mceliece/mceliece6688128/gf.h"
#include "easy-mceliece/mceliece6688128/params.h"
#include "easy-mceliece/mceliece6688128/root.h"
#include "easy-mceliece/mceliece6688128/synd.h"
#include "easy-mceliece/mceliece6688128/util.h"

void pke_keypair(uint8_t *pke_pk, uint8_t *pke_sk, const uint8_t *coins) {
  crypto_kem_keypair(pke_pk, pke_sk);
}

void sample_pke_pt(uint8_t *pke_pt, const uint8_t *coins) { gen_e(pke_pt); }

void pke_enc(uint8_t *pke_ct, const uint8_t *pke_pt, const uint8_t *pke_pk,
             const uint8_t *coins) {
  syndrome(pke_ct, pke_pk, pke_pt);
}

void pke_dec(uint8_t *pke_pt, const uint8_t *pke_ct, const uint8_t *pke_sk) {
  // NOTE: all levels of McEliece prepends 40-bytes of pseudorandom seed to
  // secret key, see crypto_kem_dec in operations.c
  pke_sk += 40;

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

#elif defined(PKE_MCELIECE6960119)
#include "easy-mceliece/mceliece6960119/benes.h"
#include "easy-mceliece/mceliece6960119/bm.h"
#include "easy-mceliece/mceliece6960119/crypto_kem.h"
#include "easy-mceliece/mceliece6960119/encrypt.h"
#include "easy-mceliece/mceliece6960119/gf.h"
#include "easy-mceliece/mceliece6960119/params.h"
#include "easy-mceliece/mceliece6960119/root.h"
#include "easy-mceliece/mceliece6960119/synd.h"
#include "easy-mceliece/mceliece6960119/util.h"

void pke_keypair(uint8_t *pke_pk, uint8_t *pke_sk, const uint8_t *coins) {
  crypto_kem_keypair(pke_pk, pke_sk);
}

void sample_pke_pt(uint8_t *pke_pt, const uint8_t *coins) { gen_e(pke_pt); }

void pke_enc(uint8_t *pke_ct, const uint8_t *pke_pt, const uint8_t *pke_pk,
             const uint8_t *coins) {
  syndrome(pke_ct, pke_pk, pke_pt);
}

void pke_dec(uint8_t *pke_pt, const uint8_t *pke_ct, const uint8_t *pke_sk) {
  // NOTE: all levels of McEliece prepends 40-bytes of pseudorandom seed to
  // secret key, see crypto_kem_dec in operations.c
  pke_sk += 40;

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

#elif defined(PKE_MCELIECE8192128)
#include "easy-mceliece/mceliece8192128/benes.h"
#include "easy-mceliece/mceliece8192128/bm.h"
#include "easy-mceliece/mceliece8192128/crypto_kem.h"
#include "easy-mceliece/mceliece8192128/encrypt.h"
#include "easy-mceliece/mceliece8192128/gf.h"
#include "easy-mceliece/mceliece8192128/params.h"
#include "easy-mceliece/mceliece8192128/root.h"
#include "easy-mceliece/mceliece8192128/synd.h"
#include "easy-mceliece/mceliece8192128/util.h"

void pke_keypair(uint8_t *pke_pk, uint8_t *pke_sk, const uint8_t *coins) {
  crypto_kem_keypair(pke_pk, pke_sk);
}

void sample_pke_pt(uint8_t *pke_pt, const uint8_t *coins) { gen_e(pke_pt); }

void pke_enc(uint8_t *pke_ct, const uint8_t *pke_pt, const uint8_t *pke_pk,
             const uint8_t *coins) {
  syndrome(pke_ct, pke_pk, pke_pt);
}

void pke_dec(uint8_t *pke_pt, const uint8_t *pke_ct, const uint8_t *pke_sk) {
  // NOTE: all levels of McEliece prepends 40-bytes of pseudorandom seed to
  // secret key, see crypto_kem_dec in operations.c
  pke_sk += 40;

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

#else
#error                                                                         \
    "Must define one of PKE_KYBER or PKE_MCELIECE[348864|460896|6688128|6960119|8192128]"
#endif
