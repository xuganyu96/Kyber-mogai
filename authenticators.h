#ifndef AUTHENTICATORS_H
#define AUTHENTICATORS_H
#include <stdint.h>
#include <stdio.h>

#define EVP_MAC_GMAC "GMAC"
#define GMAC_IVBYTES 12 // GMAC is only MAC using a nonce (96-bit in length)
#define GMAC_KEYBYTES 32
#define GMAC_TAGBYTES 16
int mac_gmac(uint8_t *digest, const uint8_t *key, const uint8_t *iv,
             const void *msg, size_t msglen);

#define EVP_MAC_POLY1305 "Poly1305"
#define POLY1305_IVBYTES 0
#define POLY1305_KEYBYTES 32
#define POLY1305_TAGBYTES 16
int mac_poly1305(uint8_t *digest, const uint8_t *key, const void *msg,
                 size_t msglen);

#define EVP_MAC_CMAC "CMAC"
#define CMAC_IVBYTES 0
#define CMAC_KEYBYTES 32
#define CMAC_TAGBYTES 16
int mac_cmac(uint8_t *digest, const uint8_t *key, const void *msg,
             const size_t msglen);

#define EVP_MAC_KMAC "KMAC-256"
#define KMAC_IVBYTES 0
#define KMAC_KEYBYTES 32
#define KMAC_TAGBYTES 32
int mac_kmac(uint8_t *digest, const uint8_t *key, size_t keylen,
             const void *msg, size_t msglen, size_t digestlen, int xof_enabled);
#endif
