#include "main.h"
#include "tribo/parse.h"
#include "tribo/plugin.h"

int main(int argc, char* argv[]) {

  // Parse command line inputs.
  TriboAppCmdInputs inputs = {0};
  triboAppCmdParser(argc, argv, &inputs);

  // Helpful logging if requested.
  if (inputs.verbosity) {
    triboAppVersionLog();
    triboAppIsaLog();
    triboAppCompilerLog();
  }

  // Do what was requested. Early exits for help/version.
  if (inputs.mode == TRIBO_APP_MODE_HELP) {
    triboAppHelpDisplay();
    return 0;
  }

  if (inputs.mode == TRIBO_APP_MODE_VERSION) {
    triboAppVersionDisplay();
    return 0;
  }

  // Load INI configuration.
  TriboUtilsIniConfig config = {0};
  if (triboUtilsParseConfig(inputs.input, &config) != 0) {
    return -1;
  }

  TriboUtilsPlugin plugin = {0};
  if (triboUtilsPluginLoadFromPath(inputs.plugin, &plugin) != 0) {
    return -1;
  }

  TriboUtilsResults results = {0};
  if (triboUtilsPluginSolve(&results, &config, &plugin) != 0) {
    return -1;
  }

  if (triboUtilsPluginUnload(&plugin) != 0) {
    return -1;
  }

  return 0;
}
