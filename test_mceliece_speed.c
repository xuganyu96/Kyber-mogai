/**
 * Performance benchmark for ML-KEM
 */
#if defined(PKE_MCELIECE348864)
#include "easy-mceliece/mceliece348864/api.h"
#include "easy-mceliece/mceliece348864/crypto_kem.h"

#elif defined(PKE_MCELIECE460896)
#include "easy-mceliece/mceliece460896/api.h"
#include "easy-mceliece/mceliece460896/crypto_kem.h"

#elif defined(PKE_MCELIECE6688128)
#include "easy-mceliece/mceliece6688128/api.h"
#include "easy-mceliece/mceliece6688128/crypto_kem.h"

#elif defined(PKE_MCELIECE6960119)
#include "easy-mceliece/mceliece6960119/api.h"
#include "easy-mceliece/mceliece6960119/crypto_kem.h"

#elif defined(PKE_MCELIECE8192128)
#include "easy-mceliece/mceliece8192128/api.h"
#include "easy-mceliece/mceliece8192128/crypto_kem.h"

#endif

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
  uint8_t kem_pk[CRYPTO_PUBLICKEYBYTES];
  uint8_t kem_sk[CRYPTO_SECRETKEYBYTES];
  uint8_t kem_ct[CRYPTO_CIPHERTEXTBYTES];
  uint8_t kem_ss[CRYPTO_BYTES];
  crypto_kem_keypair(kem_pk, kem_sk);

  uint64_t batch_times[BENCH_BATCH_COUNT];

  for (int batch = 0; batch < BENCH_BATCH_COUNT; batch++) {
    uint64_t start = get_clock_cpu();
    for (int round = 0; round < BENCH_BATCH_SIZE; round++) {
      crypto_kem_enc(kem_ct, kem_ss, kem_pk);
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
  uint8_t kem_pk[CRYPTO_PUBLICKEYBYTES];
  uint8_t kem_sk[CRYPTO_SECRETKEYBYTES];
  uint8_t kem_ct[CRYPTO_CIPHERTEXTBYTES];
  uint8_t kem_ss[CRYPTO_BYTES];
  crypto_kem_keypair(kem_pk, kem_sk);
  crypto_kem_enc(kem_ct, kem_ss, kem_pk);

  clock_t batch_times[BENCH_BATCH_COUNT];

  for (int batch = 0; batch < BENCH_BATCH_COUNT; batch++) {
#ifdef __DEBUG__
    fprintf(stderr, "Test batch %d\n", batch);
#endif
    clock_t start = get_clock_cpu();
    for (int round = 0; round < BENCH_BATCH_SIZE; round++) {
      crypto_kem_dec(kem_ss, kem_ct, kem_sk);
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
