#include "etm.h"
#include "kyber/ref/kem.h"
#include <stdio.h>
#include <stdlib.h>
#define MAX_KEYNAME 256

/** Generate a keypair, then write to separate files
 */
int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "Usage: keygen <key_name>\n");
    exit(EXIT_FAILURE);
  }
  char pk_filename[MAX_KEYNAME];
  sprintf(pk_filename, "%s.pub.bin", argv[1]);
  char sk_filename[MAX_KEYNAME];
  sprintf(sk_filename, "%s.bin", argv[1]);

  printf("public key writes to %s\n", pk_filename);
  printf("secret key writes to %s\n", sk_filename);

  uint8_t pk[KYBER_PUBLICKEYBYTES];
  uint8_t sk[KYBER_SECRETKEYBYTES];
  crypto_kem_keypair(pk, sk);

  FILE *pk_fd, *sk_fd;
  pk_fd = fopen(pk_filename, "w+");
  sk_fd = fopen(sk_filename, "w+");

  // write the public key
  fwrite(pk, KYBER_PUBLICKEYBYTES, 1, pk_fd);
  fclose(pk_fd);

  fwrite(sk, KYBER_SECRETKEYBYTES, 1, sk_fd);
  fclose(sk_fd);

  return 0;
}
