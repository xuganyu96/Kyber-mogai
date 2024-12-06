/**
 * Performance benchmark for ML-KEM
 */
#include "etmkem.h"
#include "speed.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static int uint64_t_cmp(const void *a, const void *b) {
  if (*(uint64_t *)a < *(uint64_t *)b) {
    return -1;
  }
  if (*(uint64_t *)a > *(uint64_t *)b) {
    return 1;
  }
  return 0;
}

/**
 * Compute the number of CPU cycles used to perform encapsulation
 */
static void benchmark_encapsulation_cputime(void) {
  uint8_t kem_pk[ETMKEM_PUBLICKEYBYTES];
  uint8_t kem_sk[ETMKEM_SECRETKEYBYTES];
  uint8_t kem_ct[ETMKEM_CIPHERTEXTBYTES];
  uint8_t kem_ss[ETMKEM_SSBYTES];
  etmkem_keypair(kem_pk, kem_sk);

  uint64_t batch_times[BENCH_BATCH_COUNT];

  for (int batch = 0; batch < BENCH_BATCH_COUNT; batch++) {
    uint64_t start = get_clock_cpu();
    for (int round = 0; round < BENCH_BATCH_SIZE; round++) {
      etmkem_encap(kem_ct, kem_ss, kem_pk);
    }
    uint64_t total_dur = get_clock_cpu() - start;

    uint64_t overhead_start = get_clock_cpu();
    for (int round = 0; round < BENCH_BATCH_SIZE; round++)
      ;
    uint64_t overhead_dur = get_clock_cpu() - overhead_start;
    batch_times[batch] = (total_dur - overhead_dur) / BENCH_BATCH_SIZE;
  }

  qsort(batch_times, BENCH_BATCH_COUNT, sizeof(uint64_t), uint64_t_cmp);
  uint64_t medium = batch_times[(BENCH_BATCH_COUNT - 1) / 2];
  printf("Encapsulation medium time is %llu\n", medium);
}

/**
 * Compute the number of CPU cycles used to perform encapsulation
 */
static void benchmark_decapsulation_cputime(void) {
  uint8_t kem_pk[ETMKEM_PUBLICKEYBYTES];
  uint8_t kem_sk[ETMKEM_SECRETKEYBYTES];
  uint8_t kem_ct[ETMKEM_CIPHERTEXTBYTES];
  uint8_t kem_ss[ETMKEM_SSBYTES];
  etmkem_keypair(kem_pk, kem_sk);
  etmkem_encap(kem_ct, kem_ss, kem_pk);

  clock_t batch_times[BENCH_BATCH_COUNT];

  for (int batch = 0; batch < BENCH_BATCH_COUNT; batch++) {
    clock_t start = get_clock_cpu();
    for (int round = 0; round < BENCH_BATCH_SIZE; round++) {
      etmkem_decap(kem_ss, kem_ct, kem_sk);
    }
    clock_t total_dur = get_clock_cpu() - start;

    clock_t overhead_start = get_clock_cpu();
    for (int round = 0; round < BENCH_BATCH_SIZE; round++)
      ;
    clock_t overhead_dur = get_clock_cpu() - overhead_start;
    batch_times[batch] = (total_dur - overhead_dur) / BENCH_BATCH_SIZE;
  }

  qsort(batch_times, BENCH_BATCH_COUNT, sizeof(clock_t), uint64_t_cmp);
  clock_t medium = batch_times[(BENCH_BATCH_COUNT - 1) / 2];
  printf("Decapsulation medium time is %lu\n", medium);
}

int main(void) {
  benchmark_encapsulation_cputime();
  benchmark_decapsulation_cputime();
  return 0;
}
