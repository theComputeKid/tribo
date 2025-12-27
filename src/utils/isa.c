#include "tribo/isa.h"
#include "tribo/arch.h"

#if defined(_WIN32)
// NOLINTBEGIN(misc-include-cleaner)
#  include <windows.h>
int triboUtilsIsaDetectAVX(void) {
  return IsProcessorFeaturePresent(PF_AVX_INSTRUCTIONS_AVAILABLE);
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
int triboUtilsIsaDetectAVX(void) {
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
int triboUtilsIsaDetectAVX(void) {
  unsigned int eax;
  unsigned int ebx;
  unsigned int ecx;
  unsigned int edx;
  if (!__get_cpuid(1, &eax, &ebx, &ecx, &edx)) {
    return 0;
  }
  // Check AVX bit (bit 28 of ECX)
  return (ecx & (1 << 28)) != 0;
}
int triboUtilsIsaDetectAVX512(void) {
  unsigned int eax;
  unsigned int ebx;
  unsigned int ecx;
  unsigned int edx;
  if (!__get_cpuid_count(7, 0, &eax, &ebx, &ecx, &edx)) {
    return 0;
  }
  // Check AVX-512F bit (bit 16 of EBX)
  return (ebx & (1 << 16)) != 0;
}
int triboUtilsIsaDetectNEON(void) {
  return 0;
}
int triboUtilsIsaDetectSVE2(void) {
  return 0;
}
#elif defined(TRIBO_ARM64_MACOS)
int triboUtilsIsaDetectAVX(void) {
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
