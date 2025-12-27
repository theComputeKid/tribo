#include "tribo/log.h"
#include <limits.h>
#include <stdarg.h>
#include <stdio.h>

static unsigned int TRIBO_VERBOSITY_LEVEL = 0;

void triboUtilsLogVerbositySet(unsigned int const value) {
  TRIBO_VERBOSITY_LEVEL = value;
}

static char const* iGetRelativePath(char const* path) {
  char const* ptr = __FILE__;

  while (*ptr != '\0' && *path != '\0' && *ptr == *path) {
    ptr++;
    path++;
  }

  return path;
}

void triboUtilsLogError(char const* const file, char const* const func, int const line, char const* const fmt, ...) {

  char const TRIBO_LOG_RED[] = "\033[1;31m";
  char const TRIBO_LOG_RESET[] = "\033[0m";

  va_list args;
  va_start(args, fmt);

  (void)fprintf(stderr, "%s[ERROR]%s %s:%d %s: ", TRIBO_LOG_RED, TRIBO_LOG_RESET, file, line, func);

  if (!fmt) {
    return;
  }

  (void)vfprintf(stderr, fmt, args);
  (void)fprintf(stderr, "\n");
  (void)fflush(stderr);

  va_end(args);
}

void triboUtilsLogInfo(char const* const file, char const* const func, int const line, char const* const fmt, ...) {

  if (TRIBO_VERBOSITY_LEVEL == 0) {
    return;
  }

  va_list args;
  va_start(args, fmt);

  char const* const relativeFilePath = iGetRelativePath(file);

  (void)fprintf(stdout, "[INFO] ");

  if (TRIBO_VERBOSITY_LEVEL > 1) {
    (void)fprintf(stdout, "%s:%d %s: ", relativeFilePath, line, func);
  }

  if (!fmt) {
    return;
  }

  (void)vfprintf(stdout, fmt, args);
  (void)fprintf(stdout, "\n");
  (void)fflush(stdout);

  va_end(args);
}
