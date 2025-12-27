#define TRIBO_UTILS_EXPORT
#include "triboArch.h"
#include "triboUtils.h"

#if defined(TRIBO_ARM64_WINDOWS) || defined(TRIBO_X64_WINDOWS)
// NOLINTBEGIN(misc-include-cleaner)
#  include <windows.h>
int triboUtilsIsaDetectAVX2(void) {
  return IsProcessorFeaturePresent(PF_AVX2_INSTRUCTIONS_AVAILABLE);
}
int triboUtilsIsaDetectAVX512(void) {
  return IsProcessorFeaturePresent(PF_AVX512F_INSTRUCTIONS_AVAILABLE);
}
int triboUtilsIsaDetectNEON(void) {
  return IsProcessorFeaturePresent(PF_ARM_V8_INSTRUCTIONS_AVAILABLE);
}
int triboUtilsIsaDetectSVE2(void) {
  return IsProcessorFeaturePresent(PF_ARM_SVE2_INSTRUCTIONS_AVAILABLE);
}
// NOLINTEND(misc-include-cleaner)
#elif defined(TRIBO_ARM64_LINUX)
#  include <sys/auxv.h>
int triboUtilsIsaDetectAVX2(void) {
  return 0;
}
int triboUtilsIsaDetectAVX512(void) {
  return 0;
}
int triboUtilsIsaDetectNEON(void) {
  return 1; // NEON is mandatory on AArch64
}
int triboUtilsIsaDetectSVE2(void) {
  // Value from linux kernel headers for ARM64
#  ifndef HWCAP_SVE2
#    define HWCAP_SVE2 (1 << 22)
#  endif
  unsigned long hwcaps = getauxval(AT_HWCAP);
  return (hwcaps & HWCAP_SVE2) != 0;
}
#elif defined(TRIBO_X64_LINUX)
#  include <cpuid.h>
int triboUtilsIsaDetectAVX2(void) {
  unsigned int eax;
  unsigned int ebx;
  unsigned int ecx;
  unsigned int edx;
  return __get_cpuid(7, &eax, &ebx, &ecx, &edx) && (ebx & bit_AVX2) != 0;
}
int triboUtilsIsaDetectAVX512(void) {
  unsigned int eax;
  unsigned int ebx;
  unsigned int ecx;
  unsigned int edx;
  return __get_cpuid_count(7, 0, &eax, &ebx, &ecx, &edx) && (ebx & (1 << 16)) != 0;
}
int triboUtilsIsaDetectNEON(void) {
  return 0;
}
int triboUtilsIsaDetectSVE2(void) {
  return 0;
}
#elif defined(TRIBO_ARM64_MACOS)
int triboUtilsIsaDetectAVX2(void) {
  return 0;
}
int triboUtilsIsaDetectAVX512(void) {
  return 0;
}
int triboUtilsIsaDetectNEON(void) {
  return 1;
}
int triboUtilsIsaDetectSVE2(void) {
  return 0;
}
#else
#  error "Unsupported platform for ISA detection"
#endif
