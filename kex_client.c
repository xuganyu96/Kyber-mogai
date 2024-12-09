#include "kex.h"
#include "speed.h"
#include "unistd.h"
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <time.h>

uint64_t timestamps[KEX_ROUNDS + 1];

int main(int argc, char *argv[]) {
  printf("%s\n", argv[0]);
  int auth_mode, port;
  char host[MAX_HOSTNAME_LEN];
  if (0 != parse_args(argc, argv, &auth_mode, host, &port)) {
    exit(EXIT_FAILURE);
  }

  int stream;
  struct sockaddr_in address;
  address.sin_family = AF_INET;
  address.sin_port = htons(port);

  stream = socket(AF_INET, SOCK_STREAM, 0);
  if (stream < 0) {
    fprintf(stderr, "Failed to create socket\n");
    exit(EXIT_FAILURE);
  }
  if (inet_pton(AF_INET, host, &address.sin_addr) <= 0) {
    fprintf(stderr, "Invalid address\n");
    exit(EXIT_FAILURE);
  }
  if (connect(stream, (struct socketaddr *)&address, sizeof(address)) < 0) {
    fprintf(stderr, "Failed to connect\n");
    exit(EXIT_FAILURE);
  }
  debug_network_peer(stream);

  uint8_t session_key[KEM_BYTES];
  // client will send over its authentication public key first, then listen to
  // the server for server's authentication key
  uint8_t pregen_pk_client_auth[KEM_PUBLICKEYBYTES];
  uint8_t pregen_sk_client_auth[KEM_SECRETKEYBYTES];
  uint8_t pregen_pk_server_auth[KEM_PUBLICKEYBYTES];
  kem_keypair(pregen_pk_client_auth, pregen_sk_client_auth);
  if (transmit_pk(stream, pregen_pk_client_auth)) {
    fprintf(stderr, "Client failed to send client authentication key\n");
    exit(EXIT_FAILURE);
  }
  if (receive_pk(stream, pregen_pk_server_auth)) {
    fprintf(stderr, "Client failed to receive server authentication key\n");
    exit(EXIT_FAILURE);
  }

  uint8_t *pk_server, *sk_client;
  switch (auth_mode) {
  case AUTH_NONE:
    pk_server = NULL;
    sk_client = NULL;
    break;
  case AUTH_SERVER:
    pk_server = pregen_pk_server_auth;
    sk_client = NULL;
    break;
  case AUTH_CLIENT:
    pk_server = NULL;
    sk_client = pregen_sk_client_auth;
    break;
  case AUTH_ALL:
    pk_server = pregen_pk_server_auth;
    sk_client = pregen_sk_client_auth;
    break;
  }

  timestamps[0] = get_clock_us();
  int kex_fail = 0;
  for (int i = 0; i < KEX_ROUNDS; i++) {
#ifdef __DEBUG__
    fprintf(stderr, "kex round %d\n", i);
#endif
    kex_fail |=
        client_handle(stream, sk_client, pk_server, session_key, KEM_BYTES);
    timestamps[i + 1] = get_clock_us();
  }
  println_medium_from_timestamps("Client kex: ", timestamps, KEX_ROUNDS + 1);

  if (kex_fail) {
    fprintf(stderr, "Client failed to finish key exchange\n");
  } else {
    printf("Client finished key exchange\n");
    printf("Session key: ");
    println_hexstr(session_key, KEM_BYTES);
  }

  close(stream);

  return 0;
}
