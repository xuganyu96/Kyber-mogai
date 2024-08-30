#include "../kyber/ref/kem.h"
#include "openssl/bio.h"
#include "openssl/evp.h"
#include <stdint.h>
#include <stdio.h>
#define MAX_FILENAME_LEN 256

const char keyname[] = "id_kyber";

static void print_hexstr(uint8_t *bytes, size_t bytes_len) {
  for (size_t i = 0; i < bytes_len; i++) {
    printf("%02X", bytes[i]);
  }
  printf("\n");
}

// This is probably correct
static void encode_f_base64(FILE *fd, uint8_t *data, size_t data_len) {
  BIO *b64, *bio;
  b64 = BIO_new(BIO_f_base64());
  BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);
  bio = BIO_new_fp(fd, BIO_NOCLOSE);
  BIO_push(b64, bio);
  BIO_write(b64, data, data_len);
  BIO_flush(b64);
  BIO_free_all(b64);
}

// DEBUG: This only reads the file, but did not decode the base64 thing
static size_t decode_f_base64(FILE *fd, uint8_t *data, size_t data_len) {
  BIO *b64, *bio;
  b64 = BIO_new(BIO_f_base64());
  BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);
  bio = BIO_new_fp(fd, BIO_NOCLOSE);
  BIO_push(b64, bio);
  size_t received = 0;
  while (received < data_len) {
    received += BIO_read(bio, data + received, data_len - received);
  }
  BIO_free_all(b64);

  return received;
}

static void base64_encode_decode(void) {
  uint8_t coins[KYBER_SYMBYTES] = {0};
  uint8_t pk[KYBER_PUBLICKEYBYTES];
  uint8_t sk[KYBER_SECRETKEYBYTES];
  crypto_kem_keypair_derand(pk, sk, coins);
  printf("pk len: %d\n", KYBER_PUBLICKEYBYTES);
  print_hexstr(pk, 10);
  printf("sk len: %d\n", KYBER_SECRETKEYBYTES);
  print_hexstr(sk, 10);

  // Public key writes to id_kyber.pub in the current directory
  // Secret key writes to id_kyber
  char pk_filename[MAX_FILENAME_LEN];
  char sk_filename[MAX_FILENAME_LEN];
  sprintf(pk_filename, "%s.pub", keyname);
  sprintf(sk_filename, "%s", keyname);
  FILE *pk_fd = fopen(pk_filename, "w+");
  FILE *sk_fd = fopen(sk_filename, "w+");

  // Write pk and sk into id_kyber.pub and id_kyber respectively
  encode_f_base64(pk_fd, pk, KYBER_PUBLICKEYBYTES);
  fclose(pk_fd);

  encode_f_base64(sk_fd, sk, KYBER_SECRETKEYBYTES);
  fclose(sk_fd);

  size_t decode_len;
  uint8_t pk_decode[KYBER_PUBLICKEYBYTES];
  pk_fd = fopen(pk_filename, "r");
  decode_len = decode_f_base64(pk_fd, pk_decode, KYBER_PUBLICKEYBYTES);
  printf("pk decode len: %ld\n", decode_len);
  print_hexstr(pk_decode, 10);
  fclose(pk_fd);

  uint8_t sk_decode[KYBER_SECRETKEYBYTES];
  sk_fd = fopen(sk_filename, "r");
  decode_len = decode_f_base64(sk_fd, sk_decode, KYBER_SECRETKEYBYTES);
  printf("sk decode len: %ld\n", decode_len);
  print_hexstr(sk_decode, 10);
  fclose(sk_fd);
}


int main(void) {
  uint8_t coins[KYBER_SYMBYTES] = {0};
  uint8_t pk[KYBER_PUBLICKEYBYTES];
  uint8_t sk[KYBER_SECRETKEYBYTES];
  crypto_kem_keypair_derand(pk, sk, coins);
  print_hexstr(pk, 10);

  // Define filenames
  char pk_filename[MAX_FILENAME_LEN];
  char sk_filename[MAX_FILENAME_LEN];
  sprintf(pk_filename, "%s.pub.bin", keyname);
  sprintf(sk_filename, "%s.bin", keyname);

  FILE *pk_fd = fopen(pk_filename, "w");
  fwrite(pk, KYBER_PUBLICKEYBYTES, 1, pk_fd);
  fclose(pk_fd);

  pk_fd = fopen(pk_filename, "r");
  fread(pk, KYBER_PUBLICKEYBYTES, 1, pk_fd);
  print_hexstr(pk, 10);
  fclose(pk_fd);
}
