#include <stdio.h>
#include "openssl/evp.h"
#include "openssl/bio.h"


int main(void) {
  BIO *b64, *bio;

  b64 = BIO_new(BIO_f_base64());
  bio = BIO_new_fp(
}
