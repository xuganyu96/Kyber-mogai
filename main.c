#include "authenticators.h"
#include <stdio.h>
#include <string.h>

int main(void) {
  uint8_t key[32];
  size_t keylen = 32;
  uint8_t digest[16];
  size_t digestlen = 16;
  char *msg = "Hello, world";
  if (mac_kmac(key, keylen, msg, strlen(msg), digest, digestlen, 0)) {
    printf("MAC computation successful!\n");
  }

  printf("tag is: 0x");
  for (size_t i = 0; i < digestlen; i++) {
    printf("%02X", digest[i]);
  }
  printf("\n");

  return 0;
}
