#include "speed.h"
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#if defined(__APPLE__)
#include <mach/mach_time.h>
#endif

int uint64_t_cmp(const void *a, const void *b) {
  if (*(uint64_t *)a < *(uint64_t *)b) {
    return -1;
  }
  if (*(uint64_t *)a > *(uint64_t *)b) {
    return 1;
  }
  return 0;
}

/**
 * Return the current CPU time. Good for measuring CPU cycles
 */
uint64_t get_clock_cpu(void) {
#if defined(__APPLE__)
#if defined(__DEBUG__)
  printf("Using Apple Silicon\n");
#endif
  // on Apple Silicon use high level API
  return mach_absolute_time();
#else
#if defined(__DEBUG__)
  printf("Using x86_64 register RDTSC\n");
#endif
  uint64_t result;
  __asm__ volatile("rdtsc; shlq $32,%%rdx; orq %%rdx,%%rax"
                   : "=a"(result)
                   :
                   : "%rdx");
  return result;
#endif
}

/**
 * Return the current hardware clock in nanosecond. Good for measuring actual
 * time
 */
uint64_t get_clock_ns(void) {
  struct timespec now;
  clock_gettime(CLOCK_MONOTONIC, &now);
  return now.tv_sec * 1000000000 + now.tv_nsec;
}

/**
 * Return the current real-time clock in microseconds.
 */
uint64_t get_clock_us(void) {
  struct timespec timer;
  clock_gettime(CLOCK_MONOTONIC, &timer);
  return (timer.tv_sec * 1000000) + (timer.tv_nsec / 1000);
}

/**
 * Compute the medium duration given an array of timestamps
 *
 * THIS FUNCTION IS DESTRUCTIVE! the timestamps array will be mutated
 */
void println_medium_from_timestamps(char *prefix, uint64_t *tsarr,
                                    size_t tsarr_len) {
  for (size_t i = 0; i < tsarr_len - 1; i++)
    tsarr[i] = tsarr[i + 1] - tsarr[i];
  uint64_t *durs = tsarr;
  uint64_t durslen = tsarr_len - 1;
  qsort(durs, durslen, sizeof(uint64_t), uint64_t_cmp);

  uint64_t medium = 0;
  if (durslen % 2) {
    medium = durs[durslen / 2];
  } else {
    medium = (durs[durslen / 2 - 1] + durs[durslen / 2]) / 2;
  }

  printf("%-32s medium: %16llu\n", prefix, medium);
}

void println_hexstr(uint8_t *bytes, size_t byteslen) {
  printf("0x");
  for (size_t i = 0; i < byteslen; i++) {
    printf("%02X", bytes[i]);
  }
  printf("\n");
}
