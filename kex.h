/**
 * Unauthenticated key exchange routines
 */
#include "authenticators.h"
#include "kyber/ref/kem.h"
#include <stdio.h>

#ifdef USE_MLKEM
#define KEX_SESSION_KEY_BYTES CRYPTO_BYTES
#define KEX_PUBLIC_KEY_BYTES CRYPTO_PUBLICKEYBYTES
#define KEX_SECRET_KEY_BYTES CRYPTO_SECRETKEYBYTES
#define KEX_CIPHERTEXT_BYTES CRYPTO_CIPHERTEXTBYTES
#define kex_decap crypto_kem_dec
#define kex_encap crypto_kem_enc
#define kex_keygen crypto_kem_keypair
#else
#define KEX_SESSION_KEY_BYTES ETM_SESSIONKEYBYTES
#define KEX_PUBLIC_KEY_BYTES ETM_PUBLICKEYBYTES
#define KEX_SECRET_KEY_BYTES ETM_SECRETKEYBYTES
#define KEX_CIPHERTEXT_BYTES ETM_CIPHERTEXTBYTES
#define kex_decap etm_decap
#define kex_encap etm_encap
#define kex_keygen crypto_kem_keypair
#endif

/** Read exactly data_len bytes from the file descriptor. Data is copied onto
 * data. Return 0 on success.
 */
int fread_exact(FILE *fd, uint8_t *data, size_t data_len);

/**
 * Server-side handler for key exchange.
 *
 * Return 0 upon success.
 *
 * Client's transmission must either contain exactly etm_publickeybytes bytes
 * (when doing unauthenticated key exchange) or exactly (etm_publickeybytes +
 * etm_ciphertextbytes) bytes (for doing server authentication). If client
 * transmission contains server authentication, but server's secret key is not
 * provided, then server should abort the key exchange.
 *
 * If client public key is provided, then server's transmission contains
 * (ephemeral ciphertext || client authentication). Otherwise, server's
 * transmission contains only ephemeral ciphertext.
 *
 * When deriving the session key, only non-empty shared secrets will be absorbed
 * into the Keccak. Shared secrets will always be absorbed in this order:
 * ephemeral, server authentication, client authentication.
 */
int server_handle(int stream, uint8_t *sk_server, uint8_t *pk_client,
                  uint8_t *session_key, size_t session_key_len);

/**
 * Client-side handler for key exchange.
 *
 * Return 0 upon success.
 *
 * In each key exchange, the client is responsible for running the key
 * generation routine and sending the first transmission. Depending on whether
 * server and/or client authentication is needed, the content of client's
 * transmission, and the server's response, will vary.
 * - in unauthenticated key exchange, client only sends the ephemeral public
 *   key, and server only responds with ephemeral ciphertext
 * - if server authentication is required, then caller needs to pass in server's
 *   public key; client transmission will contain (ephemeral public key ||
 *   server authentciation ciphertext); server transmissions will contain only
 *   the ephemeral ciphertext
 * - if both server authentication and client authentication are required, then
 *   caller needs to pass in server's public key and client's secret key. Client
 *   transmission will contain (ephemeral public key || server authentication
 *   ciphertext); server transmission should contain (ephemeral ciphertext ||
 *   client authentication ciphertext)
 *
 */
int client_handle(int stream, uint8_t *sk_client, uint8_t *pk_server,
                  uint8_t *session_key, size_t session_key_len);
