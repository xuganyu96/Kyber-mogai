#include "speed.h"
#include <stdint.h>
#include <stdio.h>

int main(void) {
  uint64_t start = get_clock_ns();

  for (uint64_t i = 0; i < 1000; i++) {
    printf("Mississipi\n");
  }

  uint64_t dur = get_clock_ns() - start;

  printf("Nanoseconds: %llu\n", dur);

  return 0;
}
