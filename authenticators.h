#ifndef AUTHENTICATORS_H
#define AUTHENTICATORS_H
#include <stdint.h>
#include <stdio.h>

#define EVP_MAC_POLY1305 "Poly1305"
#define POLY1305_KEYBYTES 32
#define POLY1305_TAGBYTES 16
#define EVP_MAC_GMAC "GMAC"
#define GMAC_IVBYTES 12
#define GMAC_KEYBYTES 32
#define GMAC_TAGBYTES 16
#define EVP_MAC_CMAC "CMAC"
#define CMAC_KEYBYTES 32
#define CMAC_TAGBYTES 16
#define EVP_MAC_KMAC "KMAC-256"
#define KMAC_XOF_MODE 0

#if defined(MAC_POLY1305)
#define MAC_KEYBYTES POLY1305_KEYBYTES
#define MAC_TAGBYTES POLY1305_TAGBYTES
#define MAC_IVBYTES 0
#elif defined(MAC_GMAC)
#define MAC_KEYBYTES GMAC_KEYBYTES
#define MAC_TAGBYTES GMAC_TAGBYTES
#define MAC_IVBYTES GMAC_IVBYTES
#elif defined(MAC_CMAC)
#define MAC_KEYBYTES CMAC_KEYBYTES
#define MAC_TAGBYTES CMAC_TAGBYTES
#define MAC_IVBYTES 0
#elif defined(MAC_KMAC256)
#define MAC_KEYBYTES 32
#define MAC_TAGBYTES 32
#define MAC_IVBYTES 0
#else
#error "MAC must be one of Poly1305, GMAC, CMAC, or KMAC256"
#endif

int mac_sign(uint8_t *digest, const uint8_t *key, const uint8_t *iv,
             const uint8_t *msg, size_t msglen);
int mac_cmp(const uint8_t *digest, const uint8_t *key, const uint8_t *iv,
            const uint8_t *msg, size_t msglen);

#endif
