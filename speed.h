/**
 * Helper functions for getting various kinds of times
 */
#ifndef SPEED_H
#define SPEED_H

#include <stdint.h>

// Number of batches
#define BENCH_BATCH_COUNT 101
// Number of function calls in each batch
#define BENCH_BATCH_SIZE 16

uint64_t get_clock_cpu(void);
uint64_t get_clock_ns(void);

#endif
