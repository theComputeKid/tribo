/**
 * @file
 * @brief Logging utils.
 */
#include "triboLog.h"
#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

static inline int triboLogGetVerbosity(void) {

  // Set initial value.
  static int cached = -1;

  // Return cached value if already set.
  if (cached != -1) {
    return cached;
  }

  // Read from environment variable.
  char const* const value = getenv("TRIBO_VERBOSE");

  // Default to 0 if not set.
  if (!value) {
    cached = 0;
    return cached;
  }

  char* endptr;
  long v = strtol(value, &endptr, 10);
  if (endptr != value && *endptr == '\0' && v >= 0 && v <= INT_MAX) {
    cached = (int)v;
  } else {
    cached = 0;
  }

  return cached;
}

/**
 * @brief Macro for logging in red.
 */
#define TRIBO_LOG_RED "\033[1;31m"

/**
 * @brief Macro to reset logging colour.
 */
#define TRIBO_LOG_RESET "\033[0m"

void triboLog(triboLogType type,
              char const* const file,
              char const* const func,
              int const line,
              char const* const fmt,
              ...) {

  if (triboLogGetVerbosity() == 0) {
    return;
  }

  switch (type) {
    case TRIBO_LOG_INFO:
      printf("[LOG] ");
      break;
    case TRIBO_LOG_ERROR:
      printf("%s[ERR]%s ", TRIBO_LOG_RED, TRIBO_LOG_RESET);
      break;
  }

  printf("%s:%d %s: ", file, line, func);

  if (!fmt) {
    printf("(null)\n");
    return;
  }

  va_list args;
  va_start(args, fmt);
  vprintf(fmt, args);

  va_end(args);
  printf("\n");
}
