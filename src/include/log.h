/**
 * @file
 * @brief Logging utilities.
 */
#pragma once
#include <stddef.h>
#include <stdio.h>

void triboLogSetVerbosity(size_t verbosity);
size_t triboLogGetVerbosity(void);

// Macro for logging info messages in printf format.
#define TRIBO_LOG(fmt, ...)                                                                                            \
  {                                                                                                                    \
    size_t const verbosity = triboLogGetVerbosity();                                                                   \
    if (verbosity == 0) {                                                                                              \
    } else if (verbosity == 1) {                                                                                       \
      printf("[LOG] " fmt "\n", __VA_ARGS__);                                                                          \
    } else if (verbosity == 2) {                                                                                       \
      printf("[LOG] %s:%d %s: " fmt "\n", __FILE__, __LINE__, __func__, __VA_ARGS__);                                  \
    }                                                                                                                  \
  }

#define TRIBO_COLOUR_RED "\033[1;31m"
#define TRIBO_COLOUR_RESET "\033[0m"

// Macro for logging error messages in printf format.
#define TRIBO_ERROR(fmt, ...)                                                                                          \
  (void)fprintf(stderr,                                                                                                \
                "%s[ERR]%s %s:%d %s: " fmt "\n",                                                                       \
                TRIBO_COLOUR_RED,                                                                                      \
                TRIBO_COLOUR_RESET,                                                                                    \
                __FILE__,                                                                                              \
                __LINE__,                                                                                              \
                __func__,                                                                                              \
                __VA_ARGS__);
