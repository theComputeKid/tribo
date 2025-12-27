#include "tribo/log.h"
#include "main.h"
#include "tribo/arch.h"
#include "tribo/isa.h"
#include "tribo/version.h"

void triboAppIsaLog(void) {
#if defined(TRIBO_X64)
  TRIBO_LOG_INFO("Detecting AVX: %d", triboUtilsIsaDetectAVX());
  TRIBO_LOG_INFO("Detecting AVX-512: %d", triboUtilsIsaDetectAVX512());
#elif defined(TRIBO_ARM64) && !defined(TRIBO_ARM64_MACOS)
  TRIBO_LOG_INFO("Detecting NEON: %d", triboUtilsIsaDetectNEON());
  TRIBO_LOG_INFO("Detecting SVE2: %d", triboUtilsIsaDetectSVE2());
#elif defined(TRIBO_ARM64_MACOS)
  TRIBO_LOG_INFO("Detecting NEON: %d", triboUtilsIsaDetectNEON());
#endif
}

void triboAppVersionLog(void) {
  unsigned int const major = triboUtilsVersionMajor();
  unsigned int const minor = triboUtilsVersionMinor();
  unsigned int const patch = triboUtilsVersionPatch();
  TRIBO_LOG_INFO("Version: %u.%u.%u", major, minor, patch);
}

void triboAppCompilerLog(void) {
#if defined(__INTEL_LLVM_COMPILER)
  TRIBO_LOG_INFO("Compiled with: icx %d", __INTEL_LLVM_COMPILER);
#elif defined(__clang__)
  TRIBO_LOG_INFO("Compiled with: clang %s", __clang_version__);
#elif defined(__GNUC__)
  TRIBO_LOG_INFO("Compiled with: gcc %s", __VERSION__);
#elif defined(_MSC_VER)
  TRIBO_LOG_INFO("Compiled with: msvc %d", _MSC_VER);
#else
  TRIBO_LOG_INFO("%s", "Unknown Compiler");
#endif
  TRIBO_LOG_INFO("%s", "Compiled on: " __DATE__ " (" __TIME__ ")");
}
