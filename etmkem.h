#ifndef ETMKEM_H
#define ETMKEM_H

#include "authenticators.h"
#include "pke.h"
#include <stdint.h>

#define ETMKEM_PUBLICKEYBYTES PKE_PUBLICKEYBYTES
#define ETMKEM_SECRETKEYBYTES                                                  \
  (PKE_SECRETKEYBYTES + PKE_SYMBYTES + PKE_PLAINTEXTBYTES)
#define ETMKEM_CIPHERTEXTBYTES (PKE_CIPHERTEXTBYTES + MAC_TAGBYTES)
#define ETMKEM_SSBYTES 32
#define ETMKEM_SYMBYTES PKE_SYMBYTES

void etmkem_keypair(uint8_t *pk, uint8_t *sk);
void etmkem_encap(uint8_t *ct, uint8_t *ss, const uint8_t *pk);
void etmkem_decap(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#endif
