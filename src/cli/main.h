#pragma once
// #include "tribo.h"

typedef enum {
  TRIBO_APP_MODE_RUN,
  TRIBO_APP_MODE_BENCH,
  TRIBO_APP_MODE_TEST,
  TRIBO_APP_MODE_VERSION,
  TRIBO_APP_MODE_HELP
} TriboAppMode;

// These options are specified on the command line by the user.
typedef struct TriboAppCmdInputs {
  unsigned int verbosity;
  TriboAppMode mode;
  char const* input;
  char const* output;
  char const* plugin;
} TriboAppCmdInputs;

// Parse command line inputs.
void triboAppCmdParser(int argc, char* argv[], TriboAppCmdInputs* inputs);

// Display functions.
void triboAppHelpDisplay(void);
void triboAppVersionDisplay(void);

// Logging functions.
void triboAppIsaLog(void);
void triboAppVersionLog(void);
void triboAppCompilerLog(void);
