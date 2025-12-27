#include "stdio.h"
#include "tribo/version.h"

void triboAppHelpDisplay(void) {
  char const msg[] = "triboSolver: The solution to your tribological needs.\n"
                     "Usage:\n"
                     "\ttribo [mode] [options]\n"
                     "\tmode:\n"
                     "\t\t--bench\n"
                     "\t\t--help (default)\n"
                     "\t\t--run\n"
                     "\t\t--test\n"
                     "\t\t--version\n"
                     "\toptions:\n"
                     "\t\t--input=<path>\t(default: internal defaults)\n"
                     "\t\t--output=<path>\t(default: stdout)\n"
                     "\t\t--plugin=<path>\t(default: auto-detect)\n"
                     "\t\t--verbosity=[0-2]\t(default: 0)\n";
  puts(msg);
}

void triboAppVersionDisplay(void) {
  unsigned int const major = triboUtilsVersionMajor();
  unsigned int const minor = triboUtilsVersionMinor();
  unsigned int const patch = triboUtilsVersionPatch();
  printf("triboSolver v%u.%u.%u\n", major, minor, patch);
}
