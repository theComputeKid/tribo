#define TRIBO_UTILS_EXPORT
#include "triboUtils.h"
#include <limits.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Returns non-zero if s starts with prefix
static int iParseStartsWith(char const* s, char const* prefix) {
  return strncmp(s, prefix, strlen(prefix)) == 0;
}

int triboUtilsParseString(char const* input, char const* prefix, char const** out) {
  if (iParseStartsWith(input, prefix) && strlen(input) > strlen(prefix)) {
    char const* val = input + strlen(prefix);
    *out = val;
    return 0;
  }

  return -1;
}

int triboUtilsParseFlag(char const* input, char const* prefix) {
  return (strcmp(input, prefix) == 0);
}

int triboUtilsParseSize(char const* input, char const* prefix, size_t* out) {
  char const* value;
  if (triboUtilsParseString(input, prefix, &value) != 0) {
    return -1;
  }

  char* endptr;
  size_t result = strtoull(value, &endptr, 0);

  // Check for conversion errors
  if (endptr == value || *endptr != '\0' || result >= SIZE_MAX) {
    return -1; // Invalid conversion
  }

  *out = result;
  return 0;
}

int triboUtilsParseDouble(char const* input, char const* prefix, double* out) {
  char const* value;
  if (triboUtilsParseString(input, prefix, &value) != 0) {
    return -1;
  }

  char* endptr;
  double result = strtod(value, &endptr);

  // Check for conversion errors
  if (endptr == value || *endptr != '\0' || result == HUGE_VAL) {
    return -1; // Invalid conversion
  }

  *out = result;
  return 0;
}

#define triboGetSize(name, str)                                                                                        \
  if (triboUtilsParseSize((str), #name "=", &config->name) == 0) {                                                     \
    return 0;                                                                                                          \
  }

#define triboGetDouble(name, str)                                                                                      \
  if (triboUtilsParseDouble((str), #name "=", &config->name) == 0) {                                                   \
    return 0;                                                                                                          \
  }

static int iReadLine(char* str, TriboUtilsIniConfig* const config) {

  triboGetSize(nx, str);
  triboGetSize(nx, str);
  triboGetSize(ny, str);
  triboGetSize(mgl, str);

  triboGetDouble(xin, str);
  triboGetDouble(xout, str);
  triboGetDouble(yin, str);
  triboGetDouble(yout, str);

  triboGetDouble(moes_m, str);
  triboGetDouble(moes_l, str);
  triboGetDouble(initial_h0, str);

  triboGetDouble(eps, str);
  triboGetDouble(relax_jac, str);
  triboGetDouble(relax_gs, str);
  triboGetDouble(relax_h0, str);
  triboGetSize(num_cycles, str);
  triboGetSize(it_pre, str);
  triboGetSize(it_main, str);
  triboGetSize(it_post, str);
  triboGetSize(gamma, str);
  triboGetDouble(tol_p, str);
  triboGetDouble(tol_h, str);
  triboGetDouble(tol_fb, str);

  // If we reach here, nothing was parsed.
  (void)fprintf(stderr, "Unknown parameter: %s\n", str);
  return -1;
}

int triboUtilsParseConfig(char const* inputFilePath, TriboUtilsIniConfig* config) {

  if (!inputFilePath) {
    (void)fprintf(stderr, "No input file provided.\n");
    return -1;
  }

  FILE* const file = fopen(inputFilePath, "r");

  if (!file) {
    (void)fprintf(stderr, "Failed to open input file: %s\n", inputFilePath);
    return -1;
  }

#define TRIBO_BUFFER_SIZE 32
  char line[TRIBO_BUFFER_SIZE] = {0};

  // Read line-by-line.
  int error = 0;
  while (fgets(line, sizeof(line), file)) {

    if (line[0] == '#' || line[0] == '\n') {
      // Skip comments and empty lines.
      continue;
    }

    // Remove trailing newline characters.
    size_t const newline = strcspn(line, "\r\n");
    if (newline < sizeof(line)) {
      line[newline] = 0;
    } else {
      (void)fprintf(stderr, "Max line size is %d, but line was too long: %s\n", TRIBO_BUFFER_SIZE, line);
      error = -1;
      break;
    }

    // Separate parameter name and value from each line.
    if (iReadLine(line, config) != 0) {
      error = -1;
      break;
    }
  }

  // Close the file.
  if (fclose(file) != 0) {
    (void)fprintf(stderr, "Failed to close input file: %s\n", inputFilePath);
  }
  return error;
}
