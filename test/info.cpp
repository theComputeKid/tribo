/**
 * @brief Tests for checking the INFO functions.
 *
 * @copyright Copyright (c) 2023 theComputeKid
 */
// #include "tribo/c/info.h"
#include <gtest/gtest.h>
#include <tribo.h>

TEST(info, major) {
	auto const version = triboInfoVersionMajor();
	EXPECT_EQ(version, TRIBO_PROJECT_VERSION_MAJOR);
}

TEST(info, minor) {
	auto const version = triboInfoVersionMinor();
	EXPECT_EQ(version, TRIBO_PROJECT_VERSION_MINOR);
}

TEST(info, patch) {
	auto const version = triboInfoVersionPatch();
	EXPECT_EQ(version, TRIBO_PROJECT_VERSION_PATCH);
}
