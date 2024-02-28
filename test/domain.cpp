/**
 * @brief Tests for checking the DOMAIN functions.
 *
 * @copyright Copyright (c) 2023-2024 theComputeKid
 */
#include <cstddef>
#include <gtest/gtest.h>
#include <tribo.h>

TEST(domain, setValidWithOutStatus) {
	constexpr double xin = -1.0;
	constexpr double xout = 1.0;
	constexpr size_t xn = 10;
	auto const* domain = triboDomainSet(xin, xout, xn, nullptr);
	EXPECT_NE(domain, nullptr);
	triboDomainFree(&domain);
}

TEST(domain, setValidWithStatus) {
	constexpr double xin = -1.0;
	constexpr double xout = 1.0;
	constexpr size_t xn = 10;
	int status = -1;
	auto const* domain = triboDomainSet(xin, xout, xn, &status);
	EXPECT_NE(domain, nullptr);
	triboDomainFree(&domain);
	EXPECT_EQ(status, 0);
}

TEST(domain, freeValid) {
	constexpr double xin = -1.0;
	constexpr double xout = 1.0;
	constexpr size_t xn = 10;
	auto const* domain = triboDomainSet(xin, xout, xn, nullptr);
	EXPECT_NE(domain, nullptr);
	triboDomainFree(&domain);
	EXPECT_EQ(domain, nullptr);
}

TEST(domain, setInvalidArg1WithStatus) {
	constexpr double xin = 1.0;
	constexpr double xout = 1.0;
	constexpr size_t xn = 0;
	int status = 0;
	auto const* domain = triboDomainSet(xin, xout, xn, &status);
	EXPECT_EQ(domain, nullptr);
	EXPECT_EQ(status, 1);
}

TEST(domain, setInvalidArg1WithoutStatus) {
	constexpr double xin = 1.0;
	constexpr double xout = 1.0;
	constexpr size_t xn = 0;
	auto const* domain = triboDomainSet(xin, xout, xn, nullptr);
	EXPECT_EQ(domain, nullptr);
}

TEST(domain, setInvalidArg2WithStatus) {
	constexpr double xin = -1.0;
	constexpr double xout = -1.0;
	constexpr size_t xn = 10;
	int status = 0;
	auto const* domain = triboDomainSet(xin, xout, xn, &status);
	EXPECT_EQ(domain, nullptr);
	EXPECT_EQ(status, 2);
}

TEST(domain, setInvalidArg2WithoutStatus) {
	constexpr double xin = -1.0;
	constexpr double xout = -1.0;
	constexpr size_t xn = 10;
	auto const* domain = triboDomainSet(xin, xout, xn, nullptr);
	EXPECT_EQ(domain, nullptr);
}

TEST(domain, setInvalidArg3WithStatus) {
	constexpr double xin = -1.0;
	constexpr double xout = 1.0;
	constexpr size_t xn = 0;
	int status = 0;
	auto const* domain = triboDomainSet(xin, xout, xn, &status);
	EXPECT_EQ(domain, nullptr);
	EXPECT_EQ(status, 3);
}

TEST(domain, setInvalidArg3WithoutStatus) {
	constexpr double xin = -1.0;
	constexpr double xout = 1.0;
	constexpr size_t xn = 0;
	auto const* domain = triboDomainSet(xin, xout, xn, nullptr);
	EXPECT_EQ(domain, nullptr);
}
