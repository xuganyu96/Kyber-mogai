#ifndef AUTHENTICATORS_H
#define AUTHENTICATORS_H
#include <stdint.h>
#include <stdio.h>

#define EVP_MAC_GMAC "GMAC"
#define GMAC_IVBYTES 12
#define GMAC_KEYBYTES 32
#define GMAC_TAGBYTES 16
int mac_gmac(uint8_t *key, uint8_t *iv, void *msg, size_t msglen,
             uint8_t *digest);

#define EVP_MAC_POLY1305 "Poly1305"
#define POLY1305_KEYBYTES 32
#define POLY1305_TAGBYTES 16
int mac_poly1305(uint8_t *key, void *msg, size_t msglen, uint8_t *digest);

#define EVP_MAC_CMAC "CMAC"
#define CMAC_KEYBYTES 32
#define CMAC_TAGBYTES 16
int mac_cmac(uint8_t *key, void *msg, size_t msglen, uint8_t *digest);

#define EVP_MAC_KMAC "KMAC-256"
int mac_kmac(uint8_t *key, size_t keylen, void *msg, size_t msglen,
             uint8_t *digest, size_t digestlen, int xof_enabled);
#endif
