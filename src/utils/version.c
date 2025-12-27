#include "tribo/version.h"

#define TRIBO_UTILS_VERSION_MAJOR 0
#define TRIBO_UTILS_VERSION_MINOR 0
#define TRIBO_UTILS_VERSION_PATCH 1

unsigned int triboUtilsVersionMajor(void) {
  return TRIBO_UTILS_VERSION_MAJOR;
}

unsigned int triboUtilsVersionMinor(void) {
  return TRIBO_UTILS_VERSION_MINOR;
}

unsigned int triboUtilsVersionPatch(void) {
  return TRIBO_UTILS_VERSION_PATCH;
}
