#include "tribo/parse.h"
#include "tribo/log.h"
#include <limits.h>
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

int triboUtilsParseUInt(char const* input, char const* prefix, unsigned int* out) {
  char const* value;
  if (triboUtilsParseString(input, prefix, &value) != 0) {
    return -1;
  }

  char* endptr;
  unsigned long result = strtoul(value, &endptr, 0);

  // Check for conversion errors
  if (endptr == value || *endptr != '\0' || result >= UINT_MAX) {
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
  if (endptr == value || *endptr != '\0') {
    return -1; // Invalid conversion
  }

  *out = result;
  return 0;
}

static void iGetDefaultConfig(TriboUtilsIniConfig* config) {

  config->nx = 64;
  config->ny = 64;

  config->xin = -3.0;
  config->xout = 3.0;
  config->yin = -3.0;
  config->yout = 3.0;

  config->moes_m = 7.0;
  config->moes_l = 0.0;

  config->initial_h0 = 1e-6;

  config->eps = 0.5;
  config->relax_jac = 0.8;
  config->relax_gs = 1.0;
  config->relax_h0 = 0.7;

  config->mgl = 3;

  config->num_cycles = 10;
  config->it_pre = 2;
  config->it_main = 4;
  config->it_post = 2;
  config->gamma = 2;

  config->tol_p = 1e-6;
  config->tol_h = 1e-6;
  config->tol_fb = 1e-6;
}

#define triboGetSize(name, str)                                                                                        \
  if (triboUtilsParseUInt((str), #name "=", &config->name) == 0) {                                                     \
    TRIBO_LOG_INFO("Processed: unsigned int %s = %u", #name, config->name);                                            \
    return 0;                                                                                                          \
  }

#define triboGetDouble(name, str)                                                                                      \
  if (triboUtilsParseDouble((str), #name "=", &config->name) == 0) {                                                   \
    TRIBO_LOG_INFO("Processed: double %s = %f", #name, config->name);                                                  \
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
  return -1;
}

int triboUtilsParseConfig(char const* inputFilePath, TriboUtilsIniConfig* config) {

  // Set defaults first.
  iGetDefaultConfig(config);

  if (!inputFilePath) {
    TRIBO_LOG_INFO("%s", "No file provided. Loading default configuration.");
    return 0;
  }

  TRIBO_LOG_INFO("Opening: %s", inputFilePath);
  FILE* const file = fopen(inputFilePath, "r");

  if (!file) {
    TRIBO_LOG_ERROR("Failed to open input file: %s", inputFilePath);
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
      TRIBO_LOG_ERROR("Max line size is %d, but line was too long: %s", TRIBO_BUFFER_SIZE, line);
      error = -1;
      break;
    }

    // Separate parameter name and value from each line.
    TRIBO_LOG_INFO("Processing: %s", line);
    if (iReadLine(line, config) != 0) {
      TRIBO_LOG_ERROR("Stopping. Failed to parse: %s", line);
      error = -1;
      break;
    }
  }

  // Close the file.
  TRIBO_LOG_INFO("Closing: %s", inputFilePath);
  if (fclose(file) != 0) {
    TRIBO_LOG_ERROR("Failed to close input file: %s", inputFilePath);
  }
  return error;
}
