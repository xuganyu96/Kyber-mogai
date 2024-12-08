/**
 * This header files define the input PKE APIs. The underlying implementation
 * could be one of below:
 * - ML-KEM-512/768/1024
 * - mceliece348864/460896/6688128/6960119/8192128
 *
 * concrete implementations will be in pke.c and will be controlled using macros
 */
#ifndef PKE_H
#define PKE_H
#include <stdint.h>

#if defined(PKE_KYBER)
#include "kyber/ref/params.h"
#define PKE_PUBLICKEYBYTES KYBER_INDCPA_PUBLICKEYBYTES
#define PKE_SECRETKEYBYTES KYBER_INDCPA_SECRETKEYBYTES
#define PKE_SYMBYTES KYBER_SYMBYTES
#define PKE_PLAINTEXTBYTES KYBER_INDCPA_MSGBYTES
#define PKE_CIPHERTEXTBYTES KYBER_INDCPA_BYTES

#elif defined(PKE_MCELIECE)
#include "easy-mceliece/easy-mceliece/api.h"
#include "easy-mceliece/easy-mceliece/params.h"
#define PKE_PUBLICKEYBYTES CRYPTO_PUBLICKEYBYTES
#define PKE_SECRETKEYBYTES CRYPTO_SECRETKEYBYTES
#define PKE_SYMBYTES 32
#define PKE_PLAINTEXTBYTES (SYS_N / 8)
#define PKE_CIPHERTEXTBYTES (CRYPTO_CIPHERTEXTBYTES)

#else
#error "Must define one of PKE_KYBER or PKE_MCELIECE"
#endif

void pke_keypair(uint8_t *pke_pk, uint8_t *pke_sk, const uint8_t *coins);
void sample_pke_pt(uint8_t *pke_pt, const uint8_t *coins);
void pke_enc(uint8_t *pke_ct, const uint8_t *pke_pt, const uint8_t *pke_pk,
             const uint8_t *coins);
void pke_dec(uint8_t *pke_pt, const uint8_t *pke_ct, const uint8_t *pke_sk);
#endif
