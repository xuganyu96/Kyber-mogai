/**
 * Helper functions for getting various kinds of times
 */
#ifndef SPEED_H
#define SPEED_H

#include <stdint.h>
#include <stdio.h>

// Number of batches, preferably odd
#define BENCH_BATCH_COUNT 9
// Number of function calls in each batch, preferable power of 2
#define BENCH_BATCH_SIZE 8

#define ROUNDS 1000

uint64_t get_clock_cpu(void);
uint64_t get_clock_ns(void);
uint64_t get_clock_us(void);
void println_medium_from_timestamps(char *prefix, uint64_t *ts, size_t ts_len);
int uint64_t_cmp(const void *a, const void *b);
void println_hexstr(uint8_t *bytes, size_t byteslen);

#endif
