#include "stdio.h"
#include "stdint.h"

#define EVP_MAC_GMAC "GMAC"
#define GMAC_IV_BYTES 12
#define GMAC_KEY_BYTES 32
#define GMAC_TAG_BYTES 16

#define EVP_MAC_POLY1305 "Poly1305"
#define POLY1305_KEY_BYTES 32
#define POLY1305_TAG_BYTES 16

#define EVP_MAC_CMAC "CMAC"
#define CMAC_CIPHER "AES-256-CBC"
#define CMAC_KEY_BYTES 32
#define CMAC_TAG_BYTES 16

#define EVP_MAC_KMAC "KMAC-256"
#define KMAC_KEY_BYTES 32
#define KMAC_TAG_BYTES 16

int mac_poly1305(uint8_t *key, uint8_t *msg, size_t msglen, uint8_t *digest);
int mac_gmac(uint8_t *key, uint8_t *msg, size_t msglen, uint8_t *digest);
int mac_cmac(uint8_t *key,
              uint8_t *msg,
              size_t msglen,
              uint8_t *digest);
int mac_kmac(uint8_t *key,
              uint8_t *msg,
              size_t msglen,
              uint8_t *digest);

#if (MACNAME == POLY1305)
    #define mac mac_poly1305
    #define MAC_KEY_BYTES POLY1305_KEY_BYTES
    #define MAC_TAG_BYTES POLY1305_TAG_BYTES
#elif (MACNAME == GMAC)
    #define mac mac_gmac
    #define MAC_KEY_BYTES GMAC_KEY_BYTES
    #define MAC_TAG_BYTES GMAC_TAG_BYTES
#elif (MACNAME == CMAC)
    #define mac mac_gmac
    #define MAC_KEY_BYTES CMAC_KEY_BYTES
    #define MAC_TAG_BYTES CMAC_TAG_BYTES
#endif
