/**
 * Helper functions for getting various kinds of times
 */
#ifndef SPEED_H
#define SPEED_H

#include <stdint.h>

// Number of batches, preferably odd
#define BENCH_BATCH_COUNT 9
// Number of function calls in each batch, preferable power of 2
#define BENCH_BATCH_SIZE 8

uint64_t get_clock_cpu(void);
uint64_t get_clock_ns(void);

#endif
