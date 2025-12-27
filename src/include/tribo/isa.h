/**
 * @file log.h
 * @brief Logging functions.
 */
#pragma once
#include "export.h"

/** @brief Return true if AVX is supported */
TRIBO_UTILS_LINK int triboUtilsIsaDetectAVX(void);

/** @brief Return true if AVX512 is supported */
TRIBO_UTILS_LINK int triboUtilsIsaDetectAVX512(void);

/** @brief Return true if NEON is supported */
TRIBO_UTILS_LINK int triboUtilsIsaDetectNEON(void);

/** @brief Return true if SVE2 is supported */
TRIBO_UTILS_LINK int triboUtilsIsaDetectSVE2(void);
