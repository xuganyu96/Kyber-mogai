/** Networking and debugging utilities
 */
#include "utils.h"
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>

int parse_args(int argc, char *argv[], int *auth_mode, char *host, int *port) {
  if (argc != 4) {
    fprintf(stderr, "Usage: kex <none|server|client|all> <host> <port>\n");
    return 1;
  }

  if (strcmp(argv[1], "none") == 0) {
    *auth_mode = 0;
  } else if (strcmp(argv[1], "server") == 0) {
    *auth_mode = 1;
  } else if (strcmp(argv[1], "client") == 0) {
    *auth_mode = 2;
  } else if (strcmp(argv[1], "all") == 0) {
    *auth_mode = 3;
  } else {
    fprintf(stderr,
            "Auth mode must be \"none\", \"server\", \"client\", or \"all\"\n");
    return 1;
  }

  // TODO: need to validate host and port number
  if (host) {
    strcpy(host, argv[2]);
  }
  *port = atoi(argv[3]);

  return 0;
}

void debug_network_peer(int stream) {
  // get and display peer's address
  struct sockaddr_in peer_addr;
  size_t peer_addr_len = sizeof(peer_addr);
  char peer_addr_str[INET_ADDRSTRLEN];
  getpeername(stream, (struct socketaddr *)&peer_addr,
              (socklen_t *)&peer_addr_len);
  inet_ntop(AF_INET, &(peer_addr.sin_addr), peer_addr_str, INET_ADDRSTRLEN);
  int peer_port = ntohs(peer_addr.sin_port);
  printf("Connected to %s:%d\n", peer_addr_str, peer_port);
}

void print_hexstr(uint8_t *bytes, size_t bytes_len) {
  printf("0x");
  for (size_t i = 0; i < bytes_len; i++) {
    printf("%02X", bytes[i]);
  }
  printf("\n");
}
