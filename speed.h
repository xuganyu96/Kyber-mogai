/**
 * Helper functions for getting various kinds of times
 */
#ifndef SPEED_H
#define SPEED_H

#include <stdint.h>
#include <stdio.h>

// number of rounds of tests
#ifndef SPEED_ROUNDS
#define SPEED_ROUNDS 100
#endif

uint64_t get_clock_cpu(void);
uint64_t get_clock_ns(void);
uint64_t get_clock_us(void);
void println_medium_from_timestamps(char *prefix, uint64_t *ts, size_t ts_len);
int uint64_t_cmp(const void *a, const void *b);
void println_hexstr(uint8_t *bytes, size_t byteslen);

#endif
