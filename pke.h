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
#include "kyber/ref/params.h"
#include <stdint.h>

// size of PKE public key
#define PKE_PUBLICKEYBYTES KYBER_INDCPA_PUBLICKEYBYTES
// size of PKE secret key
#define PKE_SECRETKEYBYTES KYBER_INDCPA_PUBLICKEYBYTES
// size of seed
#define PKE_SYMBYTES KYBER_SYMBYTES
// size of plaintext
#define PKE_PLAINTEXTBYTES KYBER_INDCPA_MSGBYTES
// size of ciphertext
#define PKE_CIPHERTEXTBYTES KYBER_INDCPA_BYTES

/**
 * Sample a keypair.
 */
void pke_keypair(uint8_t *pke_pk, uint8_t *pke_sk, const uint8_t *coins);

/**
 * Sample a random PKE plaintext
 *
 * For Kyber/ML-KEM, sampling random PKE plaintext is equivalent to filling a
 * 256-bit array with random bytes.
 *
 * For clasic McEliece, sampling random PKE plaintext involves generating a
 * random bit string with a specified Hamming weight (e.g. in mceliece348864,
 * plaintexts are 3488-bit strings with Hamming weight of 64).
 */
void sample_pke_pt(uint8_t *pke_pt, const uint8_t *coins);

/**
 * Encrypt the given PKE plaintext.
 *
 * With Kyber/ML-KEM, encryption is randomized. If pseudorandom seed is provided
 * then it will be passed into the underlying impl; if not, then a random seed
 * will be selecte.
 *
 * With classic mceliece, encryption is deterministic. `coins` will be ignored.
 */
void pke_enc(uint8_t *pke_ct, const uint8_t *pke_pt, const uint8_t *pke_pk,
             const uint8_t *coins);

/**
 * Decrypt the given PKE ciphertext. Decryption is always deterministic.
 */
void pke_dec(uint8_t *pke_pt, const uint8_t *pke_ct, const uint8_t *pke_sk);
#endif
