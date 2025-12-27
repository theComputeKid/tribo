#include "main.h"
#include "triboUtils.h"

int main(int argc, char* argv[]) {

  // Parse command line inputs.
  TriboAppCmdInputs inputs = {0};
  triboAppCmdParser(argc, argv, &inputs);

  // Do what was requested. Early exits for help/version.
  if (inputs.mode == TRIBO_APP_MODE_HELP) {
    triboAppInfo();
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

  double* p = NULL;
  double* h = NULL;
  plugin.Solve(config.nx,
               config.ny,
               config.xin,
               config.xout,
               config.yin,
               config.yout,
               config.moes_m,
               config.moes_l,
               config.initial_h0,
               config.eps,
               config.relax_jac,
               config.relax_gs,
               config.relax_h0,
               config.mgl,
               config.num_cycles,
               config.it_pre,
               config.it_main,
               config.it_post,
               config.gamma,
               config.tol_p,
               config.tol_h,
               config.tol_fb,
               &p,
               &h);

  if (triboUtilsPluginUnload(&plugin) != 0) {
    return -1;
  }

  return 0;
}
