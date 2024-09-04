#include "arpa/inet.h"
#include "etm.h"
#include "kex.h"
#include "netinet/in.h"
#include "stdio.h"
#include "stdlib.h"
#include "sys/socket.h"
#include "unistd.h"
#include "utils.h"

int main(int argc, char *argv[]) {
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

  uint8_t session_key[ETM_SESSIONKEYBYTES];
  uint8_t server_pk[ETM_SECRETKEYBYTES];
  uint8_t client_sk[ETM_PUBLICKEYBYTES];
  int kex_return;
  FILE *server_pk_fd = NULL;
  FILE *client_sk_fd = NULL;
  switch (auth_mode) {
  case AUTH_NONE:
    kex_return =
        client_handle(stream, NULL, NULL, session_key, ETM_SESSIONKEYBYTES);
    break;
  case AUTH_SERVER:
    server_pk_fd = fopen("id_kyber.pub.bin", "r");
    fread_exact(server_pk_fd, server_pk, ETM_PUBLICKEYBYTES);
    fclose(server_pk_fd);
    kex_return = client_handle(stream, NULL, server_pk, session_key,
                               ETM_SESSIONKEYBYTES);
    break;
  case AUTH_CLIENT:
    client_sk_fd = fopen("id_kyber.bin", "r");
    fread_exact(client_sk_fd, client_sk, ETM_SECRETKEYBYTES);
    fclose(client_sk_fd);
    kex_return = client_handle(stream, client_sk, NULL, session_key,
                               ETM_SESSIONKEYBYTES);
    break;
  case AUTH_ALL:
    server_pk_fd = fopen("id_kyber.pub.bin", "r");
    fread_exact(server_pk_fd, server_pk, ETM_PUBLICKEYBYTES);
    fclose(server_pk_fd);
    client_sk_fd = fopen("id_kyber.bin", "r");
    fread_exact(client_sk_fd, client_sk, ETM_SECRETKEYBYTES);
    fclose(client_sk_fd);
    kex_return = client_handle(stream, client_sk, server_pk, session_key,
                               ETM_SESSIONKEYBYTES);
    break;
  }

  if (kex_return != 0) {
    fprintf(stderr, "Client failed to finish key exchange\n");
  } else {
    printf("Client finished key exchange\n");
    printf("Session key: "); print_hexstr(session_key, ETM_SESSIONKEYBYTES);
  }

  close(stream);

  return 0;
}
