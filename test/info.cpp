/**
 * @brief Tests for checking the INFO functions.
 *
 * @copyright Copyright (c) 2023 theComputeKid
 */
#include <cstring>
#include <gtest/gtest.h>
#include <tribo.h>

TEST(info, versionMajor) {
  int const version = triboGetInfoVersionMajor();
  EXPECT_EQ(version, TRIBO_PROJECT_VERSION_MAJOR);
}

TEST(info, versionMinor) {
  int const version = triboGetInfoVersionMinor();
  EXPECT_EQ(version, TRIBO_PROJECT_VERSION_MINOR);
}

TEST(info, versionPatch) {
  int const version = triboGetInfoVersionPatch();
  EXPECT_EQ(version, TRIBO_PROJECT_VERSION_PATCH);
}

TEST(info, gitBranch) {
  char const* const obtained = triboGetInfoGitBranchName();
  char const* const truth = TRIBO_GIT_BRANCH_NAME;
  EXPECT_TRUE(std::strcmp(obtained, truth) == 0);
}

TEST(info, gitCommitHash) {
  char const* const obtained = triboGetInfoGitCommitHash();
  char const* const truth = TRIBO_GIT_COMMIT_HASH;
  EXPECT_TRUE(std::strcmp(obtained, truth) == 0);
}

TEST(info, gitCommitNumber) {
  int const value = triboInfoGitCommitNumber();
  EXPECT_EQ(value, TRIBO_GIT_COMMIT_NUMBER);
}
