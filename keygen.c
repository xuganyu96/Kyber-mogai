#include "etm.h"
#include "kyber/ref/kem.h"
#include "openssl/bio.h"
#include "openssl/evp.h"
#include <stdio.h>
#define MAX_KEYNAME 256

const BIO_METHOD *BIO_f_base64(void);

/** Generate a keypair, then write to separate files
 */
int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "Usage: keygen <key_name>\n");
    exit(EXIT_FAILURE);
  }
  char pk_filename[MAX_KEYNAME];
  sprintf(pk_filename, "%s.pub", argv[1]);
  char sk_filename[MAX_KEYNAME];
  sprintf(sk_filename, "%s", argv[1]);

  printf("public key writes to %s\n", pk_filename);
  printf("secret key writes to %s\n", sk_filename);

  uint8_t pk[KYBER_PUBLICKEYBYTES];
  uint8_t sk[KYBER_SECRETKEYBYTES];
  crypto_kem_keypair(pk, sk);

  FILE *pk_fd, *sk_fd;
  pk_fd = fopen(pk_filename, "w+");
  sk_fd = fopen(sk_filename, "w+");

  // write the public key
  BIO *bio, *b64;
  b64 = BIO_new(BIO_f_base64());
  bio = BIO_new_fp(pk_fd, BIO_NOCLOSE);
  BIO_push(b64, bio);
  BIO_write(b64, pk, KYBER_PUBLICKEYBYTES);
  BIO_flush(b64);
  BIO_free_all(b64);
  fclose(pk_fd);

  b64 = BIO_new(BIO_f_base64());
  bio = BIO_new_fp(sk_fd, BIO_NOCLOSE);
  BIO_push(b64, bio);
  BIO_write(b64, sk, KYBER_SECRETKEYBYTES);
  BIO_flush(b64);
  BIO_free_all(b64);
  fclose(sk_fd);

  return 0;
}
