/**
 * @file version.h
 * @brief Version information functions.
 */
#pragma once
#include "export.h"

/**
 * @brief Returns the major version of the library.
 * @return Major version number.
 */
TRIBO_UTILS_LINK unsigned int triboUtilsVersionMajor(void);

/**
 * @brief Returns the minor version of the library.
 * @return Minor version number.
 */
TRIBO_UTILS_LINK unsigned int triboUtilsVersionMinor(void);

/**
 * @brief Returns the patch version of the library.
 * @return Patch version number.
 */
TRIBO_UTILS_LINK unsigned int triboUtilsVersionPatch(void);
