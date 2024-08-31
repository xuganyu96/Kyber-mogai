/** Unilaterally authenticated key exchange
* Server has server's long-term secret key, client has server's long-term public key
*/
#include "kex.h"
#include "etm.h"
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <unistd.h>

/** Try to parse args; if args malformed, exit with non-zero exit code */
static void parse_args(int argc, char *argv[], int *port) {
  if (argc != 2) {
    fprintf(stderr, "Usage: kex_server <port>\n");
    exit(EXIT_FAILURE);
  }

  char *port_str = argv[1];
  *port = atoi(port_str);

  printf("Port is %d\n", *port);
}

int main(int argc, char *argv[]) {
  int port;
  parse_args(argc, argv, &port);

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
    fprintf(stderr, "Failed to bind socket to port %d", port);
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
  // get and display peer's address
  struct sockaddr_in peer_addr;
  size_t peer_addr_len = sizeof(peer_addr);
  char peer_addr_str[INET_ADDRSTRLEN];
  getpeername(stream, (struct socketaddr *)&peer_addr,
              (socklen_t *)&peer_addr_len);
  inet_ntop(AF_INET, &(peer_addr.sin_addr), peer_addr_str, INET_ADDRSTRLEN);
  int peer_port = ntohs(peer_addr.sin_port);
  printf("Connected to %s:%d\n", peer_addr_str, peer_port);

  FILE *server_sk_fd = fopen("id_kyber.bin", "r");
  uint8_t server_sk[ETM_SECRETKEYBYTES];
  fread_exact(server_sk_fd, server_sk, ETM_SECRETKEYBYTES);
  if (uakex_server(stream, server_sk) != 0) {
    fprintf(stderr, "Server failed to finish key exchange :(\n");
  } else {
    printf("Server finished key exchange\n");
  }

  close(stream);
  close(listener);
}
