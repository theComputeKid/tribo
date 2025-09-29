/**
 * @brief Information about the build.
 */
#include "triboLog.h"

#define TRIBO_APP_VERSION_MAJOR 0
#define TRIBO_APP_VERSION_MINOR 0
#define TRIBO_APP_VERSION_PATCH 1

static unsigned int triboVersionMajor(void) {
  return TRIBO_APP_VERSION_MAJOR;
}

static unsigned int triboVersionMinor(void) {
  return TRIBO_APP_VERSION_MINOR;
}

static unsigned int triboVersionPatch(void) {
  return TRIBO_APP_VERSION_PATCH;
}

void triboVersionDisplay(void) {
  unsigned int const major = triboVersionMajor();
  unsigned int const minor = triboVersionMinor();
  unsigned int const patch = triboVersionPatch();

  TRIBO_LOG("v%u.%u.%u", major, minor, patch);
}
