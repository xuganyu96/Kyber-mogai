#include "netinet/in.h"
#include "stdio.h"
#include "stdlib.h"
#include "sys/socket.h"
#include "unistd.h"
#include "kex.h"
#include "etm.h"
#include "arpa/inet.h"

#define PORT 8888
#define BUFFER_LEN 8192

int main(void) {
  printf("TCP Client\n");

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

  FILE *server_pk_fd = fopen("id_kyber.pub.bin", "r");
  uint8_t server_pk[ETM_PUBLICKEYBYTES];
  fread_exact(server_pk_fd, server_pk, ETM_PUBLICKEYBYTES);
  FILE *client_sk_fd = fopen("id_kyber.bin", "r");
  uint8_t client_sk[ETM_SECRETKEYBYTES];
  fread_exact(client_sk_fd, client_sk, ETM_SECRETKEYBYTES);
  if (akex_client(stream, server_pk, client_sk) != 0) {
    fprintf(stderr, "Client failed to finish key exchange\n");
  } else {
    printf("Client finished key exchange\n");
  }

  close(stream);

  return 0;
}
