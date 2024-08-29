#include "netinet/in.h"
#include "stdio.h"
#include "stdlib.h"
#include "sys/socket.h"
#include "unistd.h"
#include "kex.h"
#include "arpa/inet.h"

#define PORT 8888
#define BUFFER_LEN 8192

int main(void) {
  printf("TCP Client\n");

  int stream;
  char buffer[BUFFER_LEN];
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

  if (client_handle_stream(stream) != 0) {
    fprintf(stderr, "Client failed to finish key exchange\n");
  } else {
    printf("Client finished key exchange\n");
  }

  close(stream);

  return 0;
}
