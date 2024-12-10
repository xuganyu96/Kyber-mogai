/**
 * Unauthenticated key exchange routines
 */
#include "allkems.h"

#define KEX_ROUNDS 5
#define MAX_HOSTNAME_LEN 256
#define AUTH_NONE 0
#define AUTH_SERVER 1
#define AUTH_CLIENT 2
#define AUTH_ALL 3

int server_handle(int stream, uint8_t *sk_server, uint8_t *pk_client,
                  uint8_t *session_key, size_t session_key_len);

int client_handle(int stream, uint8_t *sk_client, uint8_t *pk_server,
                  uint8_t *session_key, size_t session_key_len);

int parse_args(int argc, char *argv[], int *auth_mode, char *host, int *port);
void debug_network_peer(int stream);
size_t read_exact(int stream, uint8_t *buf, size_t buflen);
int transmit_pk(int stream, uint8_t *pk);
int receive_pk(int stream, uint8_t *pk);
