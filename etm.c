#include "etm.h"

/**
 * Generate an ML-KEM keypair. This function will never fail
 */
void mlkempoly1305_keypair(uint8_t *pk, uint8_t *sk) {
  // TODO: figure out how to get mlkem from the reference implementation
}

/**
 * Encapsulate a secret using ML-KEM
 */
int mlkempoly1305_enc(uint8_t *ct, uint8_t *pt, uint8_t *pk) { return 0; }

/**
 * Decapsulate a secret using ML-KEM
 */
int mlkempoly1305_dec(uint8_t *pt, uint8_t *ct, uint8_t *sk) { return 0; }
