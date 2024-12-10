
/**
 * Measure the duration of PKE keygen, encryption, and decryption
 */
#include "allkems.h"
#include "speed.h"
#include <stdint.h>

uint64_t timestamps[ROUNDS + 1];

static void benchmark_kem_enc(void) {
  uint8_t pk[KEM_PUBLICKEYBYTES];
  uint8_t sk[KEM_SECRETKEYBYTES];
  uint8_t ct[KEM_CIPHERTEXTBYTES];
  uint8_t ss[KEM_BYTES];
  kem_keypair(pk, sk);

  timestamps[0] = get_clock_cpu();
  for (int i = 0; i < ROUNDS; i++) {
    kem_enc(ct, ss, pk);
    timestamps[i + 1] = get_clock_cpu();
  }

  println_medium_from_timestamps("KEM encap", timestamps, ROUNDS + 1);
}

static void benchmark_kem_dec(void) {
  uint8_t pk[KEM_PUBLICKEYBYTES];
  uint8_t sk[KEM_SECRETKEYBYTES];
  uint8_t ct[KEM_CIPHERTEXTBYTES];
  uint8_t ss[KEM_BYTES];
  uint8_t ss_cmp[KEM_BYTES];
  kem_keypair(pk, sk);
  kem_enc(ct, ss, pk);

  timestamps[0] = get_clock_cpu();
  for (int i = 0; i < ROUNDS; i++) {
    kem_dec(ss_cmp, ct, sk);
    timestamps[i + 1] = get_clock_cpu();
  }

  println_medium_from_timestamps("KEM decap", timestamps, ROUNDS + 1);
}

static void benchmark_kem_keypair(void) {
  uint8_t pk[KEM_PUBLICKEYBYTES];
  uint8_t sk[KEM_SECRETKEYBYTES];

  timestamps[0] = get_clock_cpu();
  for (int i = 0; i < ROUNDS; i++) {
    kem_keypair(pk, sk);
    timestamps[i + 1] = get_clock_cpu();
  }

  println_medium_from_timestamps("KEM keygen", timestamps, ROUNDS + 1);
}

int main(void) {
  benchmark_kem_keypair();
  benchmark_kem_enc();
  benchmark_kem_dec();
  return 0;
}
