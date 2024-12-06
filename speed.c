#include "speed.h"
#include <stdint.h>
#include <time.h>

/**
 * Return the current CPU time. Good for measuring CPU cycles
 */
uint64_t get_clock_cpu(void) {
#if defined(__APPLE__)
  // on Apple Silicon use high level API
  return clock();
#else
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
