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

  uint8_t session_key[KEX_SESSION_KEY_BYTES];
  uint8_t server_pk[KEX_PUBLIC_KEY_BYTES];
  uint8_t client_sk[KEX_SECRET_KEY_BYTES];
  int kex_return = 0;
  FILE *server_pk_fd = NULL;
  FILE *client_sk_fd = NULL;
  uint8_t *pk_server, *sk_client;
  switch (auth_mode) {
  case AUTH_NONE:
    pk_server = NULL;
    sk_client = NULL;
    break;
  case AUTH_SERVER:
    server_pk_fd = fopen("id_kyber.pub.bin", "r");
    fread_exact(server_pk_fd, server_pk, KEX_PUBLIC_KEY_BYTES);
    fclose(server_pk_fd);
    pk_server = server_pk;
    sk_client = NULL;
    break;
  case AUTH_CLIENT:
    client_sk_fd = fopen("id_kyber.bin", "r");
    fread_exact(client_sk_fd, client_sk, KEX_SECRET_KEY_BYTES);
    fclose(client_sk_fd);
    pk_server = NULL;
    sk_client = client_sk;
    break;
  case AUTH_ALL:
    server_pk_fd = fopen("id_kyber.pub.bin", "r");
    fread_exact(server_pk_fd, server_pk, KEX_PUBLIC_KEY_BYTES);
    fclose(server_pk_fd);
    client_sk_fd = fopen("id_kyber.bin", "r");
    fread_exact(client_sk_fd, client_sk, KEX_SECRET_KEY_BYTES);
    fclose(client_sk_fd);
    pk_server = server_pk;
    sk_client = client_sk;
    break;
  }

  for (int i = 0; i < KEX_ROUNDS; i++) {
    kex_return |= client_handle(stream, sk_client, pk_server, session_key,
                                KEX_SESSION_KEY_BYTES);
  }

  if (kex_return != 0) {
    fprintf(stderr, "Client failed to finish key exchange\n");
  } else {
    printf("Client finished key exchange\n");
    printf("Session key: ");
    print_hexstr(session_key, KEX_SESSION_KEY_BYTES);
  }

  close(stream);

  return 0;
}
