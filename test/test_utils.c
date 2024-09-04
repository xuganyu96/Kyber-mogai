#include "../authenticators.h"
#include "../etm.h"
#include "../utils.h"
#include "stdio.h"
#include "string.h"

#define ROUNDS 10000

static int test_parse_args(void) {
  int argc = 4;
  char *argv[] = {"kex", "none", "127.0.0.1", "8888"};

  int auth_mode, port;
  char host[MAX_HOSTNAME_LEN];

  parse_args(argc, argv, &auth_mode, host, &port);
  if (auth_mode != AUTH_NONE) {
    return 1;
  }
  if (strcmp(host, "127.0.0.1") != 0) {
    return 1;
  }
  if (port != 8888) {
    return 1;
  }
  return 0;
}

int main(void) {
  int fail = 0;

  fail |= test_parse_args();

  if (fail) {
    return 1;
  }

  printf("Ok\n");
  return 0;
}
