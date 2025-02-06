/**
* Jan 24, 2025: I have this terrible idea of just implementing everything in a
* single file. Authenticators will still be a separate set of files, as will the
* mceliece implementations, but correctness/speed tests and encrypt-then-MAC KEM's
* will all be in this single file
*/
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>

#include "easy-mceliece.h"
#include "authenticators.h"

#define CRYPTO_SYMBYTES 32
#define ETMKEM_PUBLICKEYBYTES (CRYPTO_PUBLICKEYBYTES + CRYPTO_SYMBYTES)
#define ETMKEM_SECRETKEYBYTES (CRYPTO_SECRETKEYBYTES + CRYPTO_SYMBYTES + CRYPTO_PLAINTEXTBYTES)
#define ETMKEM_CIPHERTEXTBYTES (CRYPTO_CIPHERTEXTBYTES + MAC_TAGBYTES)
#define ETMKEM_SSBYTES 32

#define SPEED_ROUNDS 10000

/**
 * ETM-KEM key generation
 *
 * ETM-KEM public key is identical to the PKE public key. ETM-KEM secret key
 * contains three components:
 * (PKE secret key || Hash of PKE public key || rejection symbol)
 */
static void etmkem_keypair(uint8_t *pk, uint8_t *sk) {
  crypto_kem_keypair(pk, sk);

  shake256(sk + CRYPTO_SECRETKEYBYTES, CRYPTO_SYMBYTES, pk, CRYPTO_PUBLICKEYBYTES);
  memcpy(pk + CRYPTO_PUBLICKEYBYTES, sk + CRYPTO_SECRETKEYBYTES, CRYPTO_SYMBYTES);

  // rejection symbol should be independently sampled from PKE key pair
  // gen_e(sk + CRYPTO_SECRETKEYBYTES + CRYPTO_SYMBYTES);
}

/**
 * Encapsulate a random secret.
 */
static void etmkem_encap(uint8_t *ct, uint8_t *ss, const uint8_t *pk) {
  // PKE public key hash and PKE plaintext is placed together so they can be
  // absorbed in a single Shake256 call
  uint8_t pkhash_pt[CRYPTO_SYMBYTES + CRYPTO_PLAINTEXTBYTES];
  gen_e(pkhash_pt + CRYPTO_SYMBYTES);
  memcpy(pkhash_pt, pk + CRYPTO_PUBLICKEYBYTES, CRYPTO_SYMBYTES);

  // Hash (PKE public key hash || PKE plaintext) into the following:
  // (preKey || MAC key || MAC IV)
  uint8_t prekey_mackey_maciv[ETMKEM_SSBYTES + MAC_KEYBYTES + MAC_IVBYTES];
  shake256(prekey_mackey_maciv, ETMKEM_SSBYTES + MAC_KEYBYTES + MAC_IVBYTES,
           pkhash_pt, CRYPTO_SYMBYTES + CRYPTO_PLAINTEXTBYTES);

  // Compute the PKE ciphertext. Pseudorandomness need to be freshly sampled
  syndrome(ct, pk, pkhash_pt + CRYPTO_SYMBYTES);
  mac_sign(ct + CRYPTO_CIPHERTEXTBYTES, prekey_mackey_maciv + ETMKEM_SSBYTES,
           prekey_mackey_maciv + ETMKEM_SSBYTES + MAC_KEYBYTES, ct,
           CRYPTO_CIPHERTEXTBYTES);

  // derive the shared secret
  uint8_t prekey_mactag[ETMKEM_SSBYTES + MAC_TAGBYTES];
  memcpy(prekey_mactag, prekey_mackey_maciv, ETMKEM_SSBYTES);
  memcpy(prekey_mactag + ETMKEM_SSBYTES, ct + CRYPTO_CIPHERTEXTBYTES,
         MAC_TAGBYTES);
  shake256(ss, ETMKEM_SSBYTES, prekey_mactag, ETMKEM_SSBYTES + MAC_TAGBYTES);
}

/**
 * Decapsulate the random secret
 */
static void etmkem_decap(uint8_t *ss, const uint8_t *ct, const uint8_t *sk) {
  uint8_t pkhash_pt[CRYPTO_SYMBYTES + CRYPTO_PLAINTEXTBYTES];
  memcpy(pkhash_pt, sk + CRYPTO_SECRETKEYBYTES, CRYPTO_SYMBYTES);
  // TODO: +40 comes from quirky mceliece implementation
  cpa_decrypt(pkhash_pt + CRYPTO_SYMBYTES, sk + 40, ct);

  // Hash (PKE public key hash || PKE plaintext) into the following:
  // (preKey || MAC key || MAC IV)
  uint8_t prekey_mackey_maciv[ETMKEM_SSBYTES + MAC_KEYBYTES + MAC_IVBYTES];
  shake256(prekey_mackey_maciv, ETMKEM_SSBYTES + MAC_KEYBYTES + MAC_IVBYTES,
           pkhash_pt, CRYPTO_SYMBYTES + CRYPTO_PLAINTEXTBYTES);

  // To achieve constant-time operation, both the true and the false shared
  // secret need to be computed
  uint8_t true_ss[ETMKEM_SSBYTES];
  uint8_t prekey_mactag[ETMKEM_SSBYTES + MAC_TAGBYTES];
  memcpy(prekey_mactag, prekey_mackey_maciv, ETMKEM_SSBYTES);
  memcpy(prekey_mactag + ETMKEM_SSBYTES, ct + CRYPTO_CIPHERTEXTBYTES,
         MAC_TAGBYTES);
  shake256(true_ss, ETMKEM_SSBYTES, prekey_mactag,
           ETMKEM_SSBYTES + MAC_TAGBYTES);
  uint8_t false_ss[ETMKEM_SSBYTES];
  uint8_t rejection_ct[CRYPTO_PLAINTEXTBYTES + CRYPTO_CIPHERTEXTBYTES + MAC_TAGBYTES];
  memcpy(rejection_ct, sk + CRYPTO_SECRETKEYBYTES + CRYPTO_SYMBYTES,
         CRYPTO_PLAINTEXTBYTES);
  memcpy(rejection_ct, ct, ETMKEM_CIPHERTEXTBYTES);
  // shake256(false_ss, ETMKEM_SSBYTES, rejection_ct,
  //          CRYPTO_PLAINTEXTBYTES + CRYPTO_CIPHERTEXTBYTES + MAC_TAGBYTES);

  if (mac_cmp(ct + CRYPTO_CIPHERTEXTBYTES, prekey_mackey_maciv + ETMKEM_SSBYTES,
              prekey_mackey_maciv + ETMKEM_SSBYTES + MAC_KEYBYTES, ct,
              CRYPTO_CIPHERTEXTBYTES)) {
    memcpy(ss, false_ss, ETMKEM_SSBYTES);
  } else {
    memcpy(ss, true_ss, ETMKEM_SSBYTES);
  }
}

static int test_correctness(size_t rounds) {
  uint8_t pk[ETMKEM_PUBLICKEYBYTES];
  uint8_t sk[ETMKEM_SECRETKEYBYTES];
  uint8_t ss[ETMKEM_SSBYTES];
  uint8_t ss_cmp[ETMKEM_SSBYTES];
  uint8_t ct[ETMKEM_CIPHERTEXTBYTES];

  int diff = 0;
  for (size_t r = 0; r < rounds; r++) {
    etmkem_keypair(pk, sk);
    etmkem_encap(ct, ss, pk);
    etmkem_decap(ss_cmp, ct, sk);

    for (int i = 0; i < ETMKEM_SSBYTES; i++) {
      diff |= ss[i] ^ ss_cmp[i];
    }
  }
  return diff;
}

static uint64_t get_percentile(const uint64_t *arr, size_t arrlen,
                               double percentile) {
  int index = (int)ceil(percentile * (arrlen - 1)); // Calculate index
  return arr[index];
}

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
 * Return the current CPU time. Good for measuring CPU cycles
 */
static uint64_t get_clock_cpu(void) {
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
static uint64_t get_clock_ns(void) {
  struct timespec now;
  clock_gettime(CLOCK_MONOTONIC, &now);
  return now.tv_sec * 1000000000 + now.tv_nsec;
}

/**
 * Return the current real-time clock in microseconds.
 */
static uint64_t get_clock_us(void) {
  struct timespec timer;
  clock_gettime(CLOCK_MONOTONIC, &timer);
  return (timer.tv_sec * 1000000) + (timer.tv_nsec / 1000);
}

/**
 * Compute the medium duration given an array of timestamps
 *
 * THIS FUNCTION IS DESTRUCTIVE! the timestamps array will be mutated
 */
static void println_medium_from_timestamps(char *prefix, uint64_t *tsarr,
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
  printf("%-32s P90   : %16llu\n", "", get_percentile(durs, durslen, 0.90));
  printf("%-32s P99   : %16llu\n", "", get_percentile(durs, durslen, 0.99));
}

static void println_hexstr(uint8_t *bytes, size_t byteslen) {
  printf("0x");
  for (size_t i = 0; i < byteslen; i++) {
    printf("%02X", bytes[i]);
  }
  printf("\n");
}

uint64_t timestamps[SPEED_ROUNDS + 1];

static void benchmark_kem_enc(void) {
  uint8_t pk[ETMKEM_PUBLICKEYBYTES];
  uint8_t sk[ETMKEM_SECRETKEYBYTES];
  uint8_t ct[ETMKEM_CIPHERTEXTBYTES];
  uint8_t ss[ETMKEM_SSBYTES];
  etmkem_keypair(pk, sk);

  timestamps[0] = get_clock_cpu();
  for (int i = 0; i < SPEED_ROUNDS; i++) {
    etmkem_encap(ct, ss, pk);
    timestamps[i + 1] = get_clock_cpu();
  }

  println_medium_from_timestamps("KEM encap", timestamps, SPEED_ROUNDS + 1);
}

static void benchmark_kem_dec(void) {
  uint8_t pk[ETMKEM_PUBLICKEYBYTES];
  uint8_t sk[ETMKEM_SECRETKEYBYTES];
  uint8_t ct[ETMKEM_CIPHERTEXTBYTES];
  uint8_t ss[ETMKEM_SSBYTES];
  uint8_t ss_cmp[ETMKEM_SSBYTES];
  etmkem_keypair(pk, sk);
  etmkem_encap(ct, ss, pk);

  timestamps[0] = get_clock_cpu();
  for (int i = 0; i < SPEED_ROUNDS; i++) {
    etmkem_decap(ss_cmp, ct, sk);
    timestamps[i + 1] = get_clock_cpu();
  }

  println_medium_from_timestamps("KEM decap", timestamps, SPEED_ROUNDS + 1);
}

static void benchmark_kem_keypair(int keygen_rounds) {
  uint8_t pk[ETMKEM_PUBLICKEYBYTES];
  uint8_t sk[ETMKEM_SECRETKEYBYTES];

  timestamps[0] = get_clock_cpu();
  for (int i = 0; i < keygen_rounds; i++) {
    etmkem_keypair(pk, sk);
    timestamps[i + 1] = get_clock_cpu();
  }

  println_medium_from_timestamps("KEM keygen", timestamps, keygen_rounds + 1);
}

int main(void) {
  int fail = 0;
  fail |= test_correctness(10);

  if (fail) {
    printf("Decapsulation failed\n");
    exit(EXIT_FAILURE);
  }

  benchmark_kem_keypair(SPEED_ROUNDS > 10 ? 10 : SPEED_ROUNDS);
  benchmark_kem_enc();
  benchmark_kem_dec();

  printf("Done\n");
  exit(EXIT_SUCCESS);
}
