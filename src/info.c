/**
 * @brief Information about the build.
 *
 * @copyright Copyright (c) 2023 theComputeKid
 */
#include "tribo.h"

// Ensure the version is provided by the build system.
#ifndef TRIBO_PROJECT_VERSION_MAJOR
#	error Project major version not defined.
#endif

#ifndef TRIBO_PROJECT_VERSION_MINOR
#	error Project minor version not defined.
#endif

#ifndef TRIBO_PROJECT_VERSION_PATCH
#	error Project patch version not defined.
#endif

int triboInfoVersionMajor(void) {
	return TRIBO_PROJECT_VERSION_MAJOR;
}

int triboInfoVersionMinor(void) {
	return TRIBO_PROJECT_VERSION_MINOR;
}

int triboInfoVersionPatch(void) {
	return TRIBO_PROJECT_VERSION_PATCH;
}
