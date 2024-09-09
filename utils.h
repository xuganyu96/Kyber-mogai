#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define AUTH_NONE 0
#define AUTH_SERVER 1
#define AUTH_CLIENT 2
#define AUTH_ALL 3
#define MAX_HOSTNAME_LEN 256

/** ripped off test_speed.c
 */
void print_results_no_overhead(const char *s, uint64_t *t, size_t tlen);

/** Convert timespect to an absolute timestamp in microseconds
 */
uint64_t clock_gettime_us(void);

/** Command-line argument parsing
 *
 * There are exactly four arguments: <auth_mode> <host> <port>. Return
 * 0 if parsing is successful
 *
 * Authentication mode must be exactly one of "none(0)", "server(1)",
 * "client(2)", "all(3)", indicating no authentication, authenticating only
 * server, authenticating only client, and mutual authentication.
 *
 * Host is used by the client to connect to the server. Host will be ignored by
 * server.
 *
 * Port is used by the server to set up the listener, and used by the client to
 * connect to the server
 */
int parse_args(int argc, char *argv[], int *auth_mode, char *host, int *port);

/** Debug networkgin peer
 * Retrieve and display the host name and port of the peer
 */
void debug_network_peer(int stream);

/** Print byte arrays to hexadecimal string
 */
void print_hexstr(uint8_t *bytes, size_t bytes_len);
