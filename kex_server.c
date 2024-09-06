/** Mutually authenticated key exchange
 * Server has server's long-term secret key, client has server's long-term
 * public key
 */
#include "etm.h"
#include "kex.h"
#include "utils.h"
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
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
  }

  stream = accept(listener, (struct socketaddr *)&server_addr,
                  (socklen_t *)&server_addr_len);
  if (stream < 0) {
    fprintf(stderr, "Failed to accept incoming connection\n");
    close(listener);
    exit(EXIT_FAILURE);
  }

  debug_network_peer(stream);

  uint8_t session_key[KEX_SESSION_KEY_BYTES];
  uint8_t server_sk[KEX_SECRET_KEY_BYTES];
  uint8_t client_pk[KEX_PUBLIC_KEY_BYTES];
  int kex_return = 0;
  FILE *server_sk_fd = NULL;
  FILE *client_pk_fd = NULL;
  uint8_t *sk_server, *pk_client;
  switch (auth_mode) {
  case AUTH_NONE:
    sk_server = NULL;
    pk_client = NULL;
    break;
  case AUTH_SERVER:
    server_sk_fd = fopen("id_kyber.bin", "r");
    fread_exact(server_sk_fd, server_sk, KEX_SECRET_KEY_BYTES);
    fclose(server_sk_fd);
    sk_server = server_sk;
    pk_client = NULL;
    break;
  case AUTH_CLIENT:
    client_pk_fd = fopen("id_kyber.pub.bin", "r");
    fread_exact(client_pk_fd, client_pk, KEX_PUBLIC_KEY_BYTES);
    fclose(client_pk_fd);
    sk_server = NULL;
    pk_client = client_pk;
    break;
  case AUTH_ALL:
    server_sk_fd = fopen("id_kyber.bin", "r");
    fread_exact(server_sk_fd, server_sk, KEX_SECRET_KEY_BYTES);
    fclose(server_sk_fd);
    client_pk_fd = fopen("id_kyber.pub.bin", "r");
    fread_exact(client_pk_fd, client_pk, KEX_PUBLIC_KEY_BYTES);
    fclose(client_pk_fd);
    sk_server = server_sk;
    pk_client = client_pk;
    break;
  }
  for (int i = 0; i < KEX_ROUNDS; i++) {
    kex_return |= server_handle(stream, sk_server, pk_client, session_key,
                                KEX_SESSION_KEY_BYTES);
  }
  if (kex_return != 0) {
    fprintf(stderr, "Server failed to finish key exchange\n");
  } else {
    printf("Server finished key exchange\n");
    printf("Session key: ");
    print_hexstr(session_key, KEX_SESSION_KEY_BYTES);
  }

  close(stream);
  close(listener);
}
