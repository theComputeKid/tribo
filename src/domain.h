/**
 * @file
 * @brief Domain setters.
 *
 * @copyright Copyright (c) 2023-2024 theComputeKid
 */
#pragma once
#include <stddef.h>

/** @brief Domain information. */
typedef struct triboDomain {

	/** @brief X-axis start value. */
	double xin;

	/** @brief X-axis end value. */
	double xout;

	/** @brief X-axis number of points. */
	size_t xn;

} triboDomain;
