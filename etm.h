#ifndef ETM_H
#define ETM_H
#include <stdint.h>

void mlkempoly1305_keypair(uint8_t *pk, uint8_t *sk);
int mlkempoly1305_enc(uint8_t *ct, uint8_t *pt, uint8_t *pk);
int mlkempoly1305_dec(uint8_t *pt, uint8_t *ct, uint8_t *sk);

#endif
