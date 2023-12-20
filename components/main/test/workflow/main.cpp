/**
 * @brief Main entry point for integration tests.
 *
 * @copyright Copyright (c) 2023 theComputeKid
 */
#include <argparse/argparse.hpp>
#include <chrono>
#include <cstdlib>
#include <exception>
#include <gtest/gtest.h>
#include <iostream>
#include <print>

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

// Ensure the git hash is provided by the build system.
#ifndef TRIBO_GIT_COMMIT_HASH
#	error Git hash not defined.
#endif

namespace {
	void iPrintHeader() {
		auto const now = std::chrono::system_clock::now();
		std::println("-----------------------------------------------------------");
		std::println("tribo workflow tests (c) theComputeKid [2022-{:%Y}]", now);
		std::println("version: {0}.{1}.{2} @ {3}",
		             TRIBO_PROJECT_VERSION_MAJOR,
		             TRIBO_PROJECT_VERSION_MINOR,
		             TRIBO_PROJECT_VERSION_PATCH,
		             TRIBO_GIT_COMMIT_HASH);
		std::println("-----------------------------------------------------------");
	}
} // namespace

auto main(int argc, char* argv[]) -> int {
	try {
		iPrintHeader();
		testing::InitGoogleTest(&argc, argv);
		[[maybe_unused]] argparse::ArgumentParser const program("test");
	} catch (std::exception const& e) {
		std::cerr << e.what() << std::flush;
		return EXIT_FAILURE;
	}
	return RUN_ALL_TESTS();
}
