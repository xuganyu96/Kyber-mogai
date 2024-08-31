/**
 * Unauthenticated key exchange routines
 */
#include "authenticators.h"
#include "kyber/ref/params.h"
#include <stdio.h>

int fread_exact(FILE *fd, uint8_t *data, size_t data_len);

int kex_server(int stream);
int kex_client(int stream);

int uakex_server(int stream, uint8_t *server_sk);
int uakex_client(int stream, const uint8_t *server_pk);

int akex_server(int stream, uint8_t *client_pk, uint8_t *server_sk);
int akex_client(int stream, uint8_t *server_pk, uint8_t *client_sk);
