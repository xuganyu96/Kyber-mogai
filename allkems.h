/**
 * Convenient abstraction over choices of KEM:
 * If any of MAC_XXXX is defined, then use ETM-KEM. Otherwise, if PKE_KYBER is
 * defined, use ML-KEM, or if PKE_MCELIECE is defined, then use classic McEliece
 */
#ifndef ALLKEMS_H
#define ALLKEMS_H

#if defined(MAC_POLY1305) || defined(MAC_GMAC) || defined(MAC_CMAC) ||         \
    defined(MAC_KMAC256)
#include "etmkem.h"
#define KEM_PUBLICKEYBYTES ETMKEM_PUBLICKEYBYTES
#define KEM_SECRETKEYBYTES ETMKEM_SECRETKEYBYTES
#define KEM_CIPHERTEXTBYTES ETMKEM_CIPHERTEXTBYTES
#define KEM_BYTES ETMKEM_SSBYTES
#define kem_keypair etmkem_keypair
#define kem_enc etmkem_encap
#define kem_dec etmkem_decap

#elif defined(PKE_KYBER)
#include "kyber/ref/kem.h"
#define KEM_PUBLICKEYBYTES CRYPTO_PUBLICKEYBYTES
#define KEM_SECRETKEYBYTES CRYPTO_SECRETKEYBYTES
#define KEM_CIPHERTEXTBYTES CRYPTO_CIPHERTEXTBYTES
#define KEM_BYTES CRYPTO_BYTES
#define kem_keypair crypto_kem_keypair
#define kem_enc crypto_kem_enc
#define kem_dec crypto_kem_dec

#elif defined(PKE_MCELIECE)
#include "easy-mceliece/easy-mceliece/api.h"
#include "easy-mceliece/easy-mceliece/crypto_kem.h"
#define KEM_PUBLICKEYBYTES CRYPTO_PUBLICKEYBYTES
#define KEM_SECRETKEYBYTES CRYPTO_SECRETKEYBYTES
#define KEM_CIPHERTEXTBYTES CRYPTO_CIPHERTEXTBYTES
#define KEM_BYTES CRYPTO_BYTES
#define kem_keypair crypto_kem_keypair
#define kem_enc crypto_kem_enc
#define kem_dec crypto_kem_dec

#else
#error "At least one of PKE_KYBER or PKE_MCELIECE must be defined"
#endif

// TODO: this is for deriving final shared secret in key exchange
#if defined(PKE_KYBER)
#include "kyber/ref/fips202.h"
#elif defined(PKE_MCELIECE)
#include "easy-mceliece/easy-mceliece/keccak.h"
#endif
#define kdf shake256

#endif
