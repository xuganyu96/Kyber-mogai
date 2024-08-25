#include "openssl/evp.h"
#include "openssl/core_names.h"
#include <stdint.h>
#include "authenticators.h"

void mac_poly1305(uint8_t *key,
                  uint8_t *msg,
                  size_t msglen,
                  uint8_t *digest) {
    EVP_MAC *mac = NULL;
    EVP_MAC_CTX *mac_ctx = NULL;
    size_t _;

    mac = EVP_MAC_fetch(NULL, "Poly1305", NULL);
    mac_ctx = EVP_MAC_CTX_new(mac);
    OSSL_PARAM params[2];
    params[0] = OSSL_PARAM_construct_octet_string(OSSL_MAC_PARAM_KEY, key, MAC_KEY_BYTES);
    params[1] = OSSL_PARAM_construct_end();
    EVP_MAC_CTX_set_params(mac_ctx, params);
    EVP_MAC_init(mac_ctx, key, MAC_KEY_BYTES, params);
    EVP_MAC_update(mac_ctx, msg, msglen);
    EVP_MAC_final(mac_ctx, digest, &_, MAC_TAG_BYTES);
    EVP_MAC_CTX_free(mac_ctx);
    EVP_MAC_free(mac);
}
