/**
 * @file log.h
 * @brief Logging functions.
 */
#pragma once
#include "export.h"

/**
 * @brief Logs an info message. Do not use directly, use the TRIBO_LOG_X macros instead.
 *
 * @param[in] file Source file name.
 * @param[in] func Function name.
 * @param[in] line Line number.
 * @param[in] fmt Printf style format string.
 * @param[in] ... Additional printf-style arguments.
 */
TRIBO_UTILS_LINK void
triboUtilsLogInfo(char const* const file, char const* const func, int const line, char const* const fmt, ...);

/**
 * @brief Logs an error message. Do not use directly, use the TRIBO_LOG_X macros instead.
 *
 * @param[in] file Source file name.
 * @param[in] func Function name.
 * @param[in] line Line number.
 * @param[in] fmt Printf style format string.
 * @param[in] ... Additional printf-style arguments.
 */
TRIBO_UTILS_LINK void
triboUtilsLogError(char const* const file, char const* const func, int const line, char const* const fmt, ...);

/**
 * @brief Initialise logging functionality.
 * @param[in] value Verbosity level of the logger.
 */
TRIBO_UTILS_LINK void triboUtilsLogVerbositySet(unsigned int value);

/** @brief Logs an printf-style info message to stdout, dependent on verbosity level. */
#define TRIBO_LOG_INFO(fmt, ...) triboUtilsLogInfo(__FILE__, __func__, __LINE__, fmt, __VA_ARGS__)

/** @brief Logs an printf-style error message. Always shown to stderr. */
#define TRIBO_LOG_ERROR(fmt, ...) triboUtilsLogError(__FILE__, __func__, __LINE__, fmt, __VA_ARGS__)
