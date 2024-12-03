#ifndef ETMKEM_H
#define ETMKEM_H

#include <stdint.h>

void etmkem_keypair_derand(uint8_t *pk, uint8_t *sk, const uint8_t *coins);
void etmkem_encap(uint8_t *ct, uint8_t *ss, const uint8_t *pk);
void etmkem_decap(uint8_t *ss, const uint8_t *ct, const uint8_t *sk);

#endif
