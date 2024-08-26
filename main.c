#include <stdio.h>
#include "openssl/evp.h"
#include "openssl/core_names.h"

#define EVP_MAC_POLY1305 "Poly1305"
#define POLY1305_KEY_BYTES 32
#define POLY1305_TAG_BYTES 16

int main(void) {
    uint8_t key[POLY1305_KEY_BYTES];
    uint8_t msg[128];
    size_t msglen = sizeof(msg);
    uint8_t digest[POLY1305_TAG_BYTES];

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
