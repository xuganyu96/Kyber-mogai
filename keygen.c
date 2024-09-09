#include "etm.h"
#include "kyber/ref/fips202.h"
#include "kyber/ref/kem.h"
#include "kyber/ref/randombytes.h"
#include "utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_KEYNAME 256

/** Generate a keypair, then write to separate files
 */
int main(int argc, char *argv[]) {
  if (!(argc == 2 || argc == 3)) {
    fprintf(stderr, "Usage: keygen <key_name> [seed]\n");
    exit(EXIT_FAILURE);
  }
  char pk_filename[MAX_KEYNAME];
  sprintf(pk_filename, "%s.pub.bin", argv[1]);
  char sk_filename[MAX_KEYNAME];
  sprintf(sk_filename, "%s.bin", argv[1]);

  uint8_t pk[KYBER_PUBLICKEYBYTES];
  uint8_t sk[KYBER_SECRETKEYBYTES];
  uint8_t coins[KYBER_SYMBYTES] = {0};
  if (argc == 3) {
    char *seed = argv[2];
    sha3_256(coins, (void *)seed, strlen(seed));
  } else {
    randombytes(coins, KYBER_SYMBYTES);
  }
  printf("Seed is: ");
  print_hexstr(coins, KYBER_SYMBYTES);
  crypto_kem_keypair_derand(pk, sk, coins);

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
