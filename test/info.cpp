/**
 * @brief Tests for checking the INFO functions.
 *
 * @copyright Copyright (c) 2023 theComputeKid
 */
#include <gtest/gtest.h>
#include <tribo.h>

TEST(info, major) {
  auto const version = triboGetInfoVersionMajor();
  EXPECT_EQ(version, TRIBO_PROJECT_VERSION_MAJOR);
}

TEST(info, minor) {
  auto const version = triboGetInfoVersionMinor();
  EXPECT_EQ(version, TRIBO_PROJECT_VERSION_MINOR);
}

TEST(info, patch) {
  auto const version = triboGetInfoVersionPatch();
  EXPECT_EQ(version, TRIBO_PROJECT_VERSION_PATCH);
}
