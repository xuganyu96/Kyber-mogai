#include "openssl/evp.h"
#include "openssl/core_names.h"
#include "assert.h"
#include <stdint.h>
#include "authenticators.h"

static void zeroize(uint8_t *arr, size_t arrlen) {
    for (size_t i = 0; i < arrlen; i++) {
         arr[i] = 0;
    }
}

/**
* Return 0 on success, 1 on failure
*/
int mac_poly1305(uint8_t *key,
                  uint8_t *msg,
                  size_t msglen,
                  uint8_t *digest) {
    // printf("Using Poly1305\n");
    EVP_MAC *mac = NULL;
    EVP_MAC_CTX *ctx = NULL;
    size_t _;

    mac = EVP_MAC_fetch(NULL, EVP_MAC_POLY1305, NULL);
    ctx = EVP_MAC_CTX_new(mac);
    OSSL_PARAM params[2];
    params[0] = OSSL_PARAM_construct_octet_string(
        OSSL_MAC_PARAM_KEY, key, POLY1305_KEY_BYTES);
    params[1] = OSSL_PARAM_construct_end();
    if (EVP_MAC_CTX_set_params(ctx, params) != 1) {
        fprintf(stderr, "Failed to set params for %s\n", EVP_MAC_POLY1305);
        return 1;
    }
    if (EVP_MAC_init(ctx, key, POLY1305_KEY_BYTES, params) != 1) {
        fprintf(stderr, "Failed to initialize %s\n", EVP_MAC_POLY1305);
        return 1;
    }
    if (EVP_MAC_update(ctx, msg, msglen) != 1) {
        fprintf(stderr, "Failed to update %s\n", EVP_MAC_POLY1305);
        return 1;
    }
    if (EVP_MAC_final(ctx, digest, &_, POLY1305_TAG_BYTES) != 1) {
        fprintf(stderr, "Failed to finalize %s\n", EVP_MAC_POLY1305);
        return 1;
    }
    EVP_MAC_CTX_free(ctx);
    EVP_MAC_free(mac);
    return 0;
}

/**
* Return 0 on success, 1 on failure
*/
int mac_gmac(uint8_t *key,
              uint8_t *msg,
              size_t msglen,
              uint8_t *digest) {
    // printf("Using GMAC\n");
    EVP_MAC *mac = NULL;
    EVP_MAC_CTX *ctx = NULL;
    OSSL_PARAM params[4];
    // TODO: This is likely not the best way to make one-time mac
    uint8_t iv[GMAC_IV_BYTES]; zeroize(iv, GMAC_IV_BYTES);
    size_t written;

    mac = EVP_MAC_fetch(NULL, EVP_MAC_GMAC, NULL);
    if (!mac) {
        fprintf(stderr, "Failed to fetch %s\n", EVP_MAC_GMAC);
        return 1;
    }
    ctx = EVP_MAC_CTX_new(mac);
    if (!ctx) {
        fprintf(stderr, "Failed to create new context for %s\n", EVP_MAC_GMAC);
        return 1;
    }
    params[0] = OSSL_PARAM_construct_utf8_string("cipher", "AES-256-GCM", 0);
    params[1] = OSSL_PARAM_construct_octet_string("iv", iv, sizeof(iv));
    params[2] = OSSL_PARAM_construct_end();

    if (EVP_MAC_CTX_set_params(ctx, params) != 1) {
        fprintf(stderr, "Failed to set params for %s\n", EVP_MAC_GMAC);
        return 1;
    }
    if (EVP_MAC_init(ctx, key, GMAC_KEY_BYTES, params) != 1) {
        fprintf(stderr, "Failed to initialize %s\n", EVP_MAC_GMAC);
        return 1;
    }
    if (EVP_MAC_update(ctx, msg, msglen) != 1) {
        fprintf(stderr, "Failed to update %s\n", EVP_MAC_GMAC);
        return 1;
    }
    if (EVP_MAC_final(ctx, digest, &written, GMAC_TAG_BYTES) != 1) {
        fprintf(stderr, "Failed to finalize %s\n", EVP_MAC_GMAC);
        return 1;
    }
    EVP_MAC_CTX_free(ctx);
    EVP_MAC_free(mac);
    return 0;
}

int mac_cmac(uint8_t *key,
              uint8_t *msg,
              size_t msglen,
              uint8_t *digest) {
    // printf("Using CMAC\n");
    EVP_MAC *mac = NULL;
    EVP_MAC_CTX *ctx = NULL;
    OSSL_PARAM params[3];
    size_t written;

    mac = EVP_MAC_fetch(NULL, EVP_MAC_CMAC, NULL);
    if (!mac) {
        fprintf(stderr, "Failed to fetch %s\n", EVP_MAC_CMAC);
        return 1;
    }
    ctx = EVP_MAC_CTX_new(mac);
    if (!ctx) {
        fprintf(stderr, "Failed to create new context for %s\n", EVP_MAC_CMAC);
        return 1;
    }
    params[0] = OSSL_PARAM_construct_utf8_string("cipher", CMAC_CIPHER, 0);
    params[1] = OSSL_PARAM_construct_octet_string("key", key, CMAC_KEY_BYTES);
    params[2] = OSSL_PARAM_construct_end();

    if (EVP_MAC_CTX_set_params(ctx, params) != 1) {
        fprintf(stderr, "Failed to set params for %s\n", EVP_MAC_CMAC);
        return 1;
    }
    if (EVP_MAC_init(ctx, key, CMAC_KEY_BYTES, params) != 1) {
        fprintf(stderr, "Failed to initialize %s\n", EVP_MAC_CMAC);
        return 1;
    }
    if (EVP_MAC_update(ctx, msg, msglen) != 1) {
        fprintf(stderr, "Failed to update %s\n", EVP_MAC_CMAC);
        return 1;
    }
    if (EVP_MAC_final(ctx, digest, &written, CMAC_TAG_BYTES) != 1) {
        fprintf(stderr, "Failed to finalize %s\n", EVP_MAC_CMAC);
        return 1;
    }
    EVP_MAC_CTX_free(ctx);
    EVP_MAC_free(mac);
    return 0;
}

int mac_kmac(uint8_t *key,
              uint8_t *msg,
              size_t msglen,
              uint8_t *digest) {
    // printf("Using KMAC\n");
    EVP_MAC *mac = NULL;
    EVP_MAC_CTX *ctx = NULL;
    OSSL_PARAM params[4];
    size_t written;
    int xof_enabled = 0;
    int tag_size = KMAC_TAG_BYTES;

    mac = EVP_MAC_fetch(NULL, EVP_MAC_KMAC, NULL);
    if (!mac) {
        fprintf(stderr, "Failed to fetch %s\n", EVP_MAC_KMAC);
        return 1;
    }
    ctx = EVP_MAC_CTX_new(mac);
    if (!ctx) {
        fprintf(stderr, "Failed to create new context for %s\n", EVP_MAC_KMAC);
        return 1;
    }
    params[0] = OSSL_PARAM_construct_octet_string("key", key, KMAC_KEY_BYTES);
    params[1] = OSSL_PARAM_construct_int("xof", &xof_enabled);
    params[2] = OSSL_PARAM_construct_int("size", &tag_size);
    params[3] = OSSL_PARAM_construct_end();

    if (EVP_MAC_CTX_set_params(ctx, params) != 1) {
        fprintf(stderr, "Failed to set params for %s\n", EVP_MAC_KMAC);
        return 1;
    }
    if (EVP_MAC_init(ctx, key, KMAC_KEY_BYTES, params) != 1) {
        fprintf(stderr, "Failed to initialize %s\n", EVP_MAC_KMAC);
        return 1;
    }
    if (EVP_MAC_update(ctx, msg, msglen) != 1) {
        fprintf(stderr, "Failed to update %s\n", EVP_MAC_KMAC);
        return 1;
    }
    if (EVP_MAC_final(ctx, digest, &written, KMAC_TAG_BYTES) != 1) {
        fprintf(stderr, "Failed to finalize %s\n", EVP_MAC_KMAC);
        return 1;
    }
    EVP_MAC_CTX_free(ctx);
    EVP_MAC_free(mac);
    return 0;
}
