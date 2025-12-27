#include "main.h"
#include "tribo/log.h"
#include "tribo/parse.h"
#include <stddef.h>

static void iCmdParserMode(char* input, TriboAppMode* mode) {
  if (triboUtilsParseFlag(input, "--help")) {
    *mode = TRIBO_APP_MODE_HELP;
  } else if (triboUtilsParseFlag(input, "--version")) {
    *mode = TRIBO_APP_MODE_VERSION;
  } else if (triboUtilsParseFlag(input, "--bench")) {
    *mode = TRIBO_APP_MODE_BENCH;
  } else if (triboUtilsParseFlag(input, "--test")) {
    *mode = TRIBO_APP_MODE_TEST;
  } else if (triboUtilsParseFlag(input, "--run")) {
    *mode = TRIBO_APP_MODE_RUN;
  }
}

static void iCmdLogMode(TriboAppCmdInputs const* const inputs) {
  switch (inputs->mode) {
    case TRIBO_APP_MODE_RUN:
      TRIBO_LOG_INFO("Mode: %s", "Run");
      break;
    case TRIBO_APP_MODE_BENCH:
      TRIBO_LOG_INFO("Mode: %s", "Benchmark");
      break;
    case TRIBO_APP_MODE_TEST:
      TRIBO_LOG_INFO("Mode: %s", "Test");
      break;
    case TRIBO_APP_MODE_VERSION:
      TRIBO_LOG_INFO("Mode: %s", "Version");
      break;
    case TRIBO_APP_MODE_HELP:
      TRIBO_LOG_INFO("Mode: %s", "Help");
      break;
    default:
      TRIBO_LOG_ERROR("Mode: %s", "Unknown");
      break;
  }
}

void triboAppCmdParser(int const argc, char* argv[], TriboAppCmdInputs* const inputs) {

  inputs->input = NULL;
  inputs->mode = TRIBO_APP_MODE_RUN;
  inputs->verbosity = 0;

  for (int i = 1; i < argc; i++) {
    triboUtilsParseString(argv[i], "--input=", &inputs->input);
    triboUtilsParseString(argv[i], "--output=", &inputs->output);
    triboUtilsParseUInt(argv[i], "--verbosity=", &inputs->verbosity);
    iCmdParserMode(argv[i], &inputs->mode);
    triboUtilsParseString(argv[i], "--plugin=", &inputs->plugin);
  }
  triboUtilsLogVerbositySet(inputs->verbosity);

  if (inputs->verbosity) {
    TRIBO_LOG_INFO("Verbosity: %d", inputs->verbosity);
    TRIBO_LOG_INFO("Input: %s", inputs->input ? inputs->input : "None");
    TRIBO_LOG_INFO("Output: %s", inputs->output ? inputs->output : "None");
    TRIBO_LOG_INFO("Plugin: %s", inputs->plugin ? inputs->plugin : "Auto");
    iCmdLogMode(inputs);
  }
}
