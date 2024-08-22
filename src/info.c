/**
 * @brief Information about the build. Must be provided by the build system.
 *
 * @copyright Copyright (c) 2023 theComputeKid
 */
#include "tribo.h"

int triboGetInfoVersionMajor(void) {
#ifndef TRIBO_PROJECT_VERSION_MAJOR
#error Project major version not defined.
#endif
  return TRIBO_PROJECT_VERSION_MAJOR;
}

int triboGetInfoVersionMinor(void) {
#ifndef TRIBO_PROJECT_VERSION_MINOR
#error Project minor version not defined.
#endif
  return TRIBO_PROJECT_VERSION_MINOR;
}

int triboGetInfoVersionPatch(void) {
#ifndef TRIBO_PROJECT_VERSION_PATCH
#error Project patch version not defined.
#endif
  return TRIBO_PROJECT_VERSION_PATCH;
}

char const *triboGetInfoGitCommitHash(void) {
#ifndef TRIBO_GIT_COMMIT_HASH
#error Project git commit hash not defined.
#endif
  static char const info[] = TRIBO_GIT_COMMIT_HASH;
  return info;
}

char const *triboGetInfoGitBranchName(void) {
#ifndef TRIBO_GIT_BRANCH_NAME
#error Project git branch not defined.
#endif
  static char const info[] = TRIBO_GIT_BRANCH_NAME;
  return info;
}

int triboInfoGitCommitNumber(void) {
#ifndef TRIBO_GIT_COMMIT_NUMBER
#error Project git commit number not defined.
#endif
  return TRIBO_GIT_COMMIT_NUMBER;
}
