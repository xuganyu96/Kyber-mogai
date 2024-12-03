#ifndef ETMKEM_H
#define ETMKEM_H

#include "authenticators.h"
#include <stdint.h>
// KEM public key will be identical to that of the PKE public key
#define ETMKEM_PUBLICKEYBYTES KYBER_INDCPA_PUBLICKEYBYTES
// KEM secret key will include PKE secret key, PKE public key (for hashing into
// MAC key), and the implicit rejection symbol
#define ETMKEM_SECRETKEYBYTES                                                  \
  (KYBER_INDCPA_SECRETKEYBYTES + KYBER_INDCPA_PUBLICKEYBYTES +                 \
   KYBER_INDCPA_MSGBYTES)
#define ETMKEM_CIPHERTEXTBYTES (KYBER_INDCPA_BYTES + POLY1305_TAGBYTES)
// The size of seed
#define ETMKEM_SYMBYTES KYBER_SYMBYTES
// Size of shared secret
#define ETMKEM_SSBYTES KYBER_SSBYTES

void etmkem_keypair_derand(uint8_t *pk, uint8_t *sk, const uint8_t *coins);
void etmkem_encap(uint8_t *ct, uint8_t *ss, const uint8_t *pk);
void etmkem_decap(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#endif
