#include "main.h"
#include "triboUtils.h"
#include <stdio.h>

static void iIsaInfo(void) {
  printf("Detected ISA: ");
  printf("AVX2 [%d] ", triboUtilsIsaDetectAVX2());
  printf("AVX-512 [%d] ", triboUtilsIsaDetectAVX512());
  printf("NEON [%d] ", triboUtilsIsaDetectNEON());
  printf("SVE2 [%d]", triboUtilsIsaDetectSVE2());
  puts("");
}

static void iCompilerInfo(void) {
  printf("Compiled with: "); // Flush any pending logs.
#if defined(__INTEL_LLVM_COMPILER)
  printf("icx %d", __INTEL_LLVM_COMPILER);
#elif defined(__clang__)
  printf("clang %s", __clang_version__);
#elif defined(__GNUC__)
  printf("gcc %s", __VERSION__);
#elif defined(_MSC_VER)
  printf("msvc %d", _MSC_VER);
#else
  printf("Unknown Compiler");
#endif
  puts("\nCompiled on: " __DATE__ " (" __TIME__ ")");
}

static void iHelp(void) {
  char const msg[] = "\ntriboSolver [0.0.1]: The solution to your tribological needs.\n\n"
                     "Usage: tribo [mode] [options]\n\n"
                     "  mode:\n"
                     "    --bench\n"
                     "    --help (default)\n"
                     "    --run\n"
                     "    --test\n\n"
                     "  options:\n"
                     "    --input=<path>\t(default: internal defaults)\n"
                     "    --output=<path>\t(default: stdout)\n"
                     "    --plugin=<path>\t(default: auto-detect)\n";
  puts(msg);
}

int triboAppInfo(void) {
  iHelp();
  iIsaInfo();
  iCompilerInfo();
  puts("");
  return 0;
}
