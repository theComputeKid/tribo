#include "main.h"
#include "triboUtils.h"
#include <stddef.h>

static void iCmdParserMode(char* input, TriboAppMode* mode) {
  if (triboUtilsParseFlag(input, "--help")) {
    *mode = TRIBO_APP_MODE_HELP;
  } else if (triboUtilsParseFlag(input, "--bench")) {
    *mode = TRIBO_APP_MODE_BENCH;
  } else if (triboUtilsParseFlag(input, "--test")) {
    *mode = TRIBO_APP_MODE_TEST;
  } else if (triboUtilsParseFlag(input, "--run")) {
    *mode = TRIBO_APP_MODE_RUN;
  }
}

void triboAppCmdParser(int const argc, char* argv[], TriboAppCmdInputs* const inputs) {

  inputs->input = NULL;
  inputs->mode = TRIBO_APP_MODE_HELP;
  inputs->output = NULL;
  inputs->plugin = NULL;

  for (int i = 1; i < argc; i++) {
    triboUtilsParseString(argv[i], "--input=", &inputs->input);
    triboUtilsParseString(argv[i], "--output=", &inputs->output);
    iCmdParserMode(argv[i], &inputs->mode);
    triboUtilsParseString(argv[i], "--plugin=", &inputs->plugin);
  }
}
