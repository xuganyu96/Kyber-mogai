#include <stdint.h>
#include <stdio.h>
#include <time.h>

static uint64_t to_microseconds(struct timespec *timer) {
  return (timer->tv_sec * 1000000) + (timer->tv_nsec / 1000);
}

int main(void) {
  struct timespec timer;

  if (0 != clock_gettime(CLOCK_MONOTONIC, &timer)) {
    fprintf(stderr, "Monotonic clock returned error\n");
  } else {
    printf("Seconds: %ld, nanosecond: %ld\n", timer.tv_sec, timer.tv_nsec);
    printf("microseconds: %llu\n", to_microseconds(&timer));
  }

  return 0;
}
