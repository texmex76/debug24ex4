#include <fcntl.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

void uint128_to_string(__uint128_t n, char *str) {
  char buf[40]; // Maximum length for 128-bit integer in decimal
  int i = 0;

  if (n == 0) {
    str[0] = '0';
    str[1] = '\0';
    return;
  }

  while (n > 0) {
    buf[i++] = '0' + (n % 10);
    n /= 10;
  }

  // Reverse the string
  int j;
  for (j = 0; j < i; j++) {
    str[j] = buf[i - j - 1];
  }
  str[i] = '\0';
}

double log_uniform() {
  double range = drand48(); // Generates a random number in [0.0, 1.0)
  double mult = 35.0;
  double exponent = -mult + range * mult;
  return pow(10, exponent);
}

int p(__uint128_t n) {
  n ^= n >> 64;
  n ^= n >> 32;
  n ^= n >> 16;
  n ^= n >> 8;
  n ^= n >> 4;
  n ^= n >> 2;
  n ^= n >> 1;
  return n & 1;
}

int main() {
  // Open /dev/urandom to read a 128-bit random number
  int fd = open("/dev/urandom", O_RDONLY);
  if (fd < 0) {
    perror("Failed to open /dev/urandom");
    return 1;
  }

  __uint128_t random_number = 0;
  ssize_t bytes_read = read(fd, &random_number, sizeof(random_number));
  close(fd);

  if (bytes_read < sizeof(random_number)) {
    perror("Failed to read random data");
    return 1;
  }

  srand48(time(NULL));
  double multiplier = log_uniform();

  // Multiply the random number by the log-uniform multiplier
  // so that we get multiple ranges of numbers
  __uint128_t scaled_random_number = (__uint128_t)(random_number * multiplier);

  char number_str[40];
  // >> 1 because we are dealing with signed numbers now
  uint128_to_string(scaled_random_number >> 1, number_str);
  printf("%s%s\n", p(scaled_random_number) ? "-" : "", number_str);

  return 0;
}
