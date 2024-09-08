/** Networking and debugging utilities
 */
#include "utils.h"
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <time.h>

static uint64_t to_microseconds(const struct timespec *timer) {
  return (timer->tv_sec * 1000000) + (timer->tv_nsec / 1000);
}

static int cmp_uint64(const void *a, const void *b) {
  if (*(uint64_t *)a < *(uint64_t *)b)
    return -1;
  if (*(uint64_t *)a > *(uint64_t *)b)
    return 1;
  return 0;
}

static uint64_t median(uint64_t *l, size_t llen) {
  qsort(l, llen, sizeof(uint64_t), cmp_uint64);

  if (llen % 2)
    return l[llen / 2];
  else
    return (l[llen / 2 - 1] + l[llen / 2]) / 2;
}

static uint64_t average(uint64_t *t, size_t tlen) {
  size_t i;
  uint64_t acc = 0;

  for (i = 0; i < tlen; i++)
    acc += t[i];

  return acc / tlen;
}

void print_results(const char *s, uint64_t *t, size_t tlen) {
  size_t i;

  if (tlen < 2) {
    fprintf(stderr, "ERROR: Need a least two cycle counts!\n");
    return;
  }

  tlen--;
  for (i = 0; i < tlen; ++i)
    t[i] = t[i + 1] - t[i];

  printf("%s\n", s);
  printf("median: %llu us/ticks\n", (unsigned long long)median(t, tlen));
  printf("average: %llu us/ticks\n", (unsigned long long)average(t, tlen));
  printf("\n");
}

uint64_t clock_gettime_us(void) {
  struct timespec timer;
  clock_gettime(CLOCK_MONOTONIC, &timer);
  return to_microseconds(&timer);
}

int parse_args(int argc, char *argv[], int *auth_mode, char *host, int *port) {
  if (argc != 4) {
    fprintf(stderr, "Usage: kex <none|server|client|all> <host> <port>\n");
    return 1;
  }

  if (strcmp(argv[1], "none") == 0) {
    *auth_mode = 0;
  } else if (strcmp(argv[1], "server") == 0) {
    *auth_mode = 1;
  } else if (strcmp(argv[1], "client") == 0) {
    *auth_mode = 2;
  } else if (strcmp(argv[1], "all") == 0) {
    *auth_mode = 3;
  } else {
    fprintf(stderr,
            "Auth mode must be \"none\", \"server\", \"client\", or \"all\"\n");
    return 1;
  }

  // TODO: need to validate host and port number
  if (host) {
    strcpy(host, argv[2]);
  }
  *port = atoi(argv[3]);

  return 0;
}

void debug_network_peer(int stream) {
  // get and display peer's address
  struct sockaddr_in peer_addr;
  size_t peer_addr_len = sizeof(peer_addr);
  char peer_addr_str[INET_ADDRSTRLEN];
  getpeername(stream, (struct socketaddr *)&peer_addr,
              (socklen_t *)&peer_addr_len);
  inet_ntop(AF_INET, &(peer_addr.sin_addr), peer_addr_str, INET_ADDRSTRLEN);
  int peer_port = ntohs(peer_addr.sin_port);
  printf("Connected to %s:%d\n", peer_addr_str, peer_port);
}

void print_hexstr(uint8_t *bytes, size_t bytes_len) {
  printf("0x");
  for (size_t i = 0; i < bytes_len; i++) {
    printf("%02X", bytes[i]);
  }
  printf("\n");
}
