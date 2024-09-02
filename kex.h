/**
 * Unauthenticated key exchange routines
 */
#include "authenticators.h"
#include "kyber/ref/params.h"
#include <stdio.h>

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
int server_handle(int stream, uint8_t *sk_server, size_t sk_server_len,
                  uint8_t *pk_client, size_t pk_client_len);
int client_handle(int stream, uint8_t *sk_client, size_t sk_client_len,
                  uint8_t *pk_server, size_t pk_server_len);
