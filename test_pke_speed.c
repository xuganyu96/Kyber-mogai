/**
 * Measure the duration of PKE keygen, encryption, and decryption
 */
#include "pke.h"
#include "speed.h"
#include <stdint.h>

uint64_t timestamps[ROUNDS + 1];

static void benchmark_pke_enc(void) {
  uint8_t pk[PKE_PUBLICKEYBYTES];
  uint8_t sk[PKE_SECRETKEYBYTES];
  uint8_t pt[PKE_PLAINTEXTBYTES];
  uint8_t ct[PKE_CIPHERTEXTBYTES];
  uint8_t coins[PKE_SYMBYTES];
  pke_keypair(pk, sk, coins);
  sample_pke_pt(pt, coins);

  timestamps[0] = get_clock_cpu();
  for (int i = 0; i < ROUNDS; i++) {
    pke_enc(ct, pt, pk, coins);
    timestamps[i + 1] = get_clock_cpu();
  }

  println_medium_from_timestamps("PKE encrypt", timestamps, ROUNDS + 1);
}

static void benchmark_pke_dec(void) {
  uint8_t pk[PKE_PUBLICKEYBYTES];
  uint8_t sk[PKE_SECRETKEYBYTES];
  uint8_t pt[PKE_PLAINTEXTBYTES];
  uint8_t pt_cmp[PKE_PLAINTEXTBYTES];
  uint8_t ct[PKE_CIPHERTEXTBYTES];
  uint8_t coins[PKE_SYMBYTES];
  pke_keypair(pk, sk, coins);
  sample_pke_pt(pt, coins);
  pke_enc(ct, pt, pk, coins);

  timestamps[0] = get_clock_cpu();
  for (int i = 0; i < ROUNDS; i++) {
    pke_dec(pt_cmp, ct, sk);
    timestamps[i + 1] = get_clock_cpu();
  }

  println_medium_from_timestamps("PKE decrypt", timestamps, ROUNDS + 1);
}

static void benchmark_pke_keypair(void) {
  uint8_t pk[PKE_PUBLICKEYBYTES];
  uint8_t sk[PKE_SECRETKEYBYTES];
  uint8_t coins[PKE_SYMBYTES];

  timestamps[0] = get_clock_cpu();
  for (int i = 0; i < ROUNDS; i++) {
    pke_keypair(pk, sk, coins);
    timestamps[i + 1] = get_clock_cpu();
  }

  println_medium_from_timestamps("PKE keygen", timestamps, ROUNDS + 1);
}

int main(void) {
  benchmark_pke_keypair();
  benchmark_pke_enc();
  benchmark_pke_dec();
  return 0;
}
