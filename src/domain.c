/**
 * @file
 * @brief Implementation of the domain setters.
 *
 * @copyright Copyright (c) 2023-2024 theComputeKid
 */
#include "domain.h"
#include "tribo.h"
#include <stddef.h>
#include <stdlib.h>

static void* iReturnErrorStatus(int const arg, int* const status) {
	if (status != NULL) {
		*status = arg;
	}
	return NULL;
}

triboDomainPtr triboDomainSet(double const xin, double const xout, size_t const xn, int* const status) {
	if (xin >= 0) {
		return iReturnErrorStatus(1, status);
	}
	if (xout <= 0) {
		return iReturnErrorStatus(2, status);
	}
	if (xn == 0) {
		return iReturnErrorStatus(3, status);
	}

	triboDomain* const domain = malloc(sizeof(triboDomain));
	domain->xin = xin;
	domain->xout = xout;
	domain->xn = xn;

	if (status != NULL) {
		*status = 0;
	}

	return domain;
}

void triboDomainFree(triboDomainPtr* domain) {
	free((void*)*domain);
	*domain = NULL;
}
