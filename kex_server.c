/** Mutually authenticated key exchange
 * Server has server's long-term secret key, client has server's long-term
 * public key
 */
#include "allkems.h"
#include "kex.h"
#include "speed.h"
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <time.h>
#include <unistd.h>

uint64_t timestamps[KEX_ROUNDS];

int main(int argc, char *argv[]) {
  printf("%s\n", argv[0]);
  int auth_mode, port;
  if (0 != parse_args(argc, argv, &auth_mode, NULL, &port)) {
    exit(EXIT_FAILURE);
  }

  // listener is a socket, socket binds to a port, socket accepts a connection,
  // a TCP connection is a stream
  int listener, stream;
  struct sockaddr_in server_addr;
  size_t server_addr_len = sizeof(server_addr);

  server_addr.sin_family = AF_INET;
  server_addr.sin_addr.s_addr = INADDR_ANY;
  server_addr.sin_port = htons(port);

  listener = socket(AF_INET, SOCK_STREAM, 0);
  if (!listener) {
    fprintf(stderr, "Failed to create socket\n");
    close(listener);
    exit(EXIT_FAILURE);
  }

  if (bind(listener, (struct socketaddr *)&server_addr, server_addr_len) < 0) {
    fprintf(stderr, "Failed to bind socket to port %d\n", port);
    close(listener);
    exit(EXIT_FAILURE);
  }

  if (listen(listener, 3) < 0) {
    fprintf(stderr, "Failed to listen on port %d\n", port);
    close(listener);
    exit(EXIT_FAILURE);
  } else {
    printf("Listening in on port %d\n", port);
  }

  stream = accept(listener, (struct socketaddr *)&server_addr,
                  (socklen_t *)&server_addr_len);
  if (stream < 0) {
    fprintf(stderr, "Failed to accept incoming connection\n");
    close(listener);
    exit(EXIT_FAILURE);
  }

  debug_network_peer(stream);

  uint8_t session_key[KEM_BYTES];
  // pre-generate authentication keys. server will listen for client
  // authentication key first, then transmit server authentication key
  uint8_t pregen_pk_client_auth[KEM_PUBLICKEYBYTES];
  uint8_t pregen_pk_server_auth[KEM_PUBLICKEYBYTES];
  uint8_t pregen_sk_server_auth[KEM_SECRETKEYBYTES];
  kem_keypair(pregen_pk_server_auth, pregen_sk_server_auth);
  if (receive_pk(stream, pregen_pk_client_auth)) {
    fprintf(stderr, "Server failed to receive client authentication key\n");
    exit(EXIT_FAILURE);
  }
  if (transmit_pk(stream, pregen_pk_server_auth)) {
    fprintf(stderr, "Server failed to send server authentication key\n");
    exit(EXIT_FAILURE);
  }

  uint8_t *sk_server, *pk_client;
  switch (auth_mode) {
  case AUTH_NONE:
    sk_server = NULL;
    pk_client = NULL;
    break;
  case AUTH_SERVER:
    sk_server = pregen_sk_server_auth;
    pk_client = NULL;
    break;
  case AUTH_CLIENT:
    sk_server = NULL;
    pk_client = pregen_pk_client_auth;
    break;
  case AUTH_ALL:
    sk_server = pregen_sk_server_auth;
    pk_client = pregen_pk_client_auth;
    break;
  }
  timestamps[0] = get_clock_us();
  int kex_fail = 0;
  for (int i = 0; i < KEX_ROUNDS; i++) {
    kex_fail |=
        server_handle(stream, sk_server, pk_client, session_key, KEM_BYTES);
    timestamps[i + 1] = get_clock_us();
  }
  println_medium_from_timestamps("Server kex: ", timestamps, KEX_ROUNDS + 1);
  if (kex_fail) {
    fprintf(stderr, "Server failed to finish key exchange\n");
  } else {
    printf("Server finished key exchange\n");
    printf("Session key: ");
    println_hexstr(session_key, KEM_BYTES);
  }

  close(stream);
  close(listener);
}
