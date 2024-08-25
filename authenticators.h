#include "stdio.h"
#include "stdint.h"
#define MAC_KEY_BYTES 32
#define MAC_TAG_BYTES 16

#define mac mac_poly1305

void mac_poly1305(uint8_t *key, uint8_t *msg, size_t msglen, uint8_t *digest);
