#include "authenticators.h"
#include "openssl/core_names.h"
#include "openssl/evp.h"
#include <limits.h>
#include <stdint.h>

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

/**
 * Compute the Poly1305 digest for the input message using the input key. The
 * tag is written to `digest`. Return 1 if the operation is ok; return 0 on
 * error.
 *
 * Caller is responsible for supplying correctly sized buffer for the key and
 * the digest. Poly1305 uses a 256-bit key (POLY1305_KEYBYTES) and 128-bit tag
 * (POLY1305_TAGBYTES).
 *
 * Interestingly if the first 16 bytes of the key is set to 0, then the tag will
 * be the same as the second 16 bytes of the key. This indicates that this
 * implementation of Poly1305 is a one-time Carter-Wegman MAC where the second
 * half of the key serves as an one-time pad:
 * tag = PolyHash(m, k_1) XOR k_2
 */
static int mac_poly1305(uint8_t *digest, const uint8_t *key, const void *msg,
                        size_t msglen) {
#ifdef __DEBUG__
  fprintf(stderr, "called mac_poly1305\n");
#endif
  EVP_MAC *mac = NULL;
  EVP_MAC_CTX *ctx = NULL;
  size_t _;

  mac = EVP_MAC_fetch(NULL, EVP_MAC_POLY1305, NULL);
  if (!mac) {
    fprintf(stderr, "Failed to fetch %s\n", EVP_MAC_POLY1305);
    return 0;
  }
  ctx = EVP_MAC_CTX_new(mac);
  if (!ctx) {
    fprintf(stderr, "Failed to create new context for %s\n", EVP_MAC_POLY1305);
    return 0;
  }
  OSSL_PARAM params[2];
  params[0] = OSSL_PARAM_construct_octet_string(OSSL_MAC_PARAM_KEY, (void *)key,
                                                POLY1305_KEYBYTES);
  params[1] = OSSL_PARAM_construct_end();
  if (EVP_MAC_CTX_set_params(ctx, params) != 1) {
    fprintf(stderr, "Failed to set params for %s\n", EVP_MAC_POLY1305);
    return 0;
  }
  if (EVP_MAC_init(ctx, key, POLY1305_KEYBYTES, params) != 1) {
    fprintf(stderr, "Failed to initialize %s\n", EVP_MAC_POLY1305);
    return 0;
  }
  if (EVP_MAC_update(ctx, msg, msglen) != 1) {
    fprintf(stderr, "Failed to update %s\n", EVP_MAC_POLY1305);
    return 0;
  }
  if (EVP_MAC_final(ctx, digest, &_, POLY1305_TAGBYTES) != 1) {
    fprintf(stderr, "Failed to finalize %s\n", EVP_MAC_POLY1305);
    return 0;
  }
  EVP_MAC_CTX_free(ctx);
  EVP_MAC_free(mac);
  return 1;
}

/**
 * Compute GMAC, which is equivalent to using AES-256-GCM and passing all data
 * as associated data. Return 1 upon success, 0 on error.
 *
 * Caller is responsible for supplying correctly sized buffer for the key
 * (GMAC_KEYBYTES), the iv (GMAC_IVBYTES), and the digest (GMAC_TAGBYTES).
 *
 * Because GMAC uses AES-256-GCM under the hood, a unique nonce/IV is needed for
 * each distinct message. In the encrypt-then-MAC transformation, we will hash
 * the message to get both the symmetric key and the IV so that IV is distinct
 * for each message.
 *
 * TODO: find a standalone GF(2^128) Carter-Wegman MAC implementation?
 * TODO: there might be other ways to get IV, or we can sample random IV and
 * append them to the tag
 */
static int mac_gmac(uint8_t *digest, const uint8_t *key, const uint8_t *iv,
                    const void *msg, size_t msglen) {
#ifdef __DEBUG__
  fprintf(stderr, "called mac_gmac\n");
#endif
  EVP_MAC *mac = NULL;
  EVP_MAC_CTX *ctx = NULL;
  OSSL_PARAM params[4];
  size_t written;

  mac = EVP_MAC_fetch(NULL, EVP_MAC_GMAC, NULL);
  if (!mac) {
    fprintf(stderr, "Failed to fetch %s\n", EVP_MAC_GMAC);
    return 0;
  }
  ctx = EVP_MAC_CTX_new(mac);
  if (!ctx) {
    fprintf(stderr, "Failed to create new context for %s\n", EVP_MAC_GMAC);
    return 0;
  }
  params[0] = OSSL_PARAM_construct_utf8_string("cipher", "AES-256-GCM", 0);
  params[1] = OSSL_PARAM_construct_octet_string("iv", (void *)iv, GMAC_IVBYTES);
  params[2] = OSSL_PARAM_construct_end();

  if (EVP_MAC_CTX_set_params(ctx, params) != 1) {
    fprintf(stderr, "Failed to set params for %s\n", EVP_MAC_GMAC);
    return 0;
  }
  if (EVP_MAC_init(ctx, key, GMAC_KEYBYTES, params) != 1) {
    fprintf(stderr, "Failed to initialize %s\n", EVP_MAC_GMAC);
    return 0;
  }
  if (EVP_MAC_update(ctx, msg, msglen) != 1) {
    fprintf(stderr, "Failed to update %s\n", EVP_MAC_GMAC);
    return 0;
  }
  if (EVP_MAC_final(ctx, digest, &written, GMAC_TAGBYTES) != 1) {
    fprintf(stderr, "Failed to finalize %s\n", EVP_MAC_GMAC);
    return 0;
  }
  EVP_MAC_CTX_free(ctx);
  EVP_MAC_free(mac);
  return 0;
}

/**
 * Compute CMAC, as specified in NIST SP 800-38B. Return 1 upon success and 0
 * on error.
 *
 * Caller is responsible for supplying correctly sized buffer for the key
 * (CMAC_KEYBYTES) and the digest (CMAC_TAGBYTES).
 */
static int mac_cmac(uint8_t *digest, const uint8_t *key, const void *msg,
                    const size_t msglen) {
#ifdef __DEBUG__
  fprintf(stderr, "called mac_cmac\n");
#endif
  EVP_MAC *mac = NULL;
  EVP_MAC_CTX *ctx = NULL;
  OSSL_PARAM params[3];
  size_t written;

  mac = EVP_MAC_fetch(NULL, EVP_MAC_CMAC, NULL);
  if (!mac) {
    fprintf(stderr, "Failed to fetch %s\n", EVP_MAC_CMAC);
    return 0;
  }
  ctx = EVP_MAC_CTX_new(mac);
  if (!ctx) {
    fprintf(stderr, "Failed to create new context for %s\n", EVP_MAC_CMAC);
    return 0;
  }
  params[0] = OSSL_PARAM_construct_utf8_string("cipher", "AES-256-CBC", 0);
  params[1] =
      OSSL_PARAM_construct_octet_string("key", (void *)key, CMAC_KEYBYTES);
  params[2] = OSSL_PARAM_construct_end();

  if (EVP_MAC_CTX_set_params(ctx, params) != 1) {
    fprintf(stderr, "Failed to set params for %s\n", EVP_MAC_CMAC);
    return 0;
  }
  if (EVP_MAC_init(ctx, key, CMAC_KEYBYTES, params) != 1) {
    fprintf(stderr, "Failed to initialize %s\n", EVP_MAC_CMAC);
    return 0;
  }
  if (EVP_MAC_update(ctx, msg, msglen) != 1) {
    fprintf(stderr, "Failed to update %s\n", EVP_MAC_CMAC);
    return 0;
  }
  if (EVP_MAC_final(ctx, digest, &written, CMAC_TAGBYTES) != 1) {
    fprintf(stderr, "Failed to finalize %s\n", EVP_MAC_CMAC);
    return 0;
  }
  EVP_MAC_CTX_free(ctx);
  EVP_MAC_free(mac);
  return 1;
}

/**
 * Compute KMAC (specifically KMAC-256) as specified in NIST SP800-185. Return 1
 * upon success and 0 on error.
 *
 * KMAC has variable key size and digest size. Key size must be between 4 and
 * 512 bytes (inclusive). Tag size can range from 0 to (2^2040) bits, though
 * 128/192/256 bits are usually recommended.
 *
 * XOF mode is recommended if the tag size is supposed to be variable. In this
 * use case we should probably not use it.
 */
static int mac_kmac(uint8_t *digest, const uint8_t *key, size_t keylen,
                    const void *msg, size_t msglen, size_t digestlen,
                    int xof_enabled) {
#ifdef __DEBUG__
  fprintf(stderr, "called mac_kmac256\n");
#endif
  EVP_MAC *mac = NULL;
  EVP_MAC_CTX *ctx = NULL;
  OSSL_PARAM params[4];
  size_t written;
  int macsize;

  if (!(keylen >= 4 && keylen <= 512)) {
    fprintf(stderr, "KMAC-256 key size must be between 4 and 512 bytes\n");
    return 0;
  }
  if (digestlen >= INT_MAX) {
    fprintf(stderr, "digest length is longer than the limit %d\n", INT_MAX);
    return 0;
  } else {
    macsize = (int)digestlen;
  }

  mac = EVP_MAC_fetch(NULL, EVP_MAC_KMAC, NULL);
  if (!mac) {
    fprintf(stderr, "Failed to fetch %s\n", EVP_MAC_KMAC);
    return 0;
  }
  ctx = EVP_MAC_CTX_new(mac);
  if (!ctx) {
    fprintf(stderr, "Failed to create new context for %s\n", EVP_MAC_KMAC);
    return 0;
  }
  params[0] = OSSL_PARAM_construct_octet_string("key", (void *)key, keylen);
  params[1] = OSSL_PARAM_construct_int("xof", &xof_enabled);
  params[2] = OSSL_PARAM_construct_int("size", &macsize);
  params[3] = OSSL_PARAM_construct_end();

  if (EVP_MAC_CTX_set_params(ctx, params) != 1) {
    fprintf(stderr, "Failed to set params for %s\n", EVP_MAC_KMAC);
    return 0;
  }
  if (EVP_MAC_init(ctx, key, keylen, params) != 1) {
    fprintf(stderr, "Failed to initialize %s\n", EVP_MAC_KMAC);
    return 0;
  }
  if (EVP_MAC_update(ctx, msg, msglen) != 1) {
    fprintf(stderr, "Failed to update %s\n", EVP_MAC_KMAC);
    return 0;
  }
  if (EVP_MAC_final(ctx, digest, &written, digestlen) != 1) {
    fprintf(stderr, "Failed to finalize %s\n", EVP_MAC_KMAC);
    return 0;
  }
  EVP_MAC_CTX_free(ctx);
  EVP_MAC_free(mac);
  return 1;
}

int mac_sign(uint8_t *digest, const uint8_t *key, const uint8_t *iv,
             const uint8_t *msg, size_t msglen) {
#if defined(MAC_POLY1305)
  return mac_poly1305(digest, key, msg, msglen);
#elif defined(MAC_GMAC)
  return mac_gmac(digest, key, iv, msg, msglen);
#elif defined(MAC_CMAC)
  return mac_cmac(digest, key, msg, msglen);
#elif defined(MAC_KMAC256)
  return mac_kmac(digest, key, MAC_KEYBYTES, msg, msglen, MAC_TAGBYTES,
                  KMAC_XOF_MODE);
#else
#error "MAC must be one of Poly1305, GMAC, CMAC, or MAC256"
#endif
}

int mac_cmp(const uint8_t *digest, const uint8_t *key, const uint8_t *iv,
            const uint8_t *msg, size_t msglen) {
  uint8_t digestcmp[MAC_TAGBYTES];
  mac_sign(digestcmp, key, iv, msg, msglen);
  int diff = 0;

  for (int i = 0; i < MAC_TAGBYTES; i++) {
    diff |= digest[i] ^ digestcmp[i];
  }

  return diff;
}
