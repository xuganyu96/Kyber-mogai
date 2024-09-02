#include "arpa/inet.h"
#include "kex.h"
#include "netinet/in.h"
#include "stdio.h"
#include "stdlib.h"
#include "sys/socket.h"
#include "unistd.h"

#define PORT 8888
#define BUFFER_LEN 8192

int main(void) {
  int stream;
  struct sockaddr_in address;
  address.sin_family = AF_INET;
  address.sin_port = htons(PORT);

  stream = socket(AF_INET, SOCK_STREAM, 0);
  if (stream < 0) {
    fprintf(stderr, "Failed to create socket\n");
    exit(EXIT_FAILURE);
  }
  if (inet_pton(AF_INET, "127.0.0.1", &address.sin_addr) <= 0) {
    fprintf(stderr, "Invalid address\n");
    exit(EXIT_FAILURE);
  }
  if (connect(stream, (struct socketaddr *)&address, sizeof(address)) < 0) {
    fprintf(stderr, "Failed to connect\n");
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

  if (client_handle(stream, NULL, 0, NULL, 0) != 0) {
    fprintf(stderr, "Client failed to finish key exchange\n");
  } else {
    printf("Client finished key exchange\n");
  }

  close(stream);

  return 0;
}
