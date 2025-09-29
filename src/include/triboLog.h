/**
 * @file
 * @brief Logging utils.
 */
#pragma once

/**
 * @brief Logging levels.
 */
typedef enum {
  TRIBO_LOG_INFO = 0,
  TRIBO_LOG_ERROR = 1,
} triboLogType;

/**
 * @brief Logs a message if verbosity is enabled.
 * @param[in] type The type of log message (info/error etc).
 * @param[in] file The source file where the log is called.
 * @param[in] func The function name where the log is called.
 * @param[in] line The line number where the log is called.
 * @param[in] fmt printf-style format string.
 * @param[in] ... Arguments for the format string.
 */
void triboLog(triboLogType type, char const* file, char const* func, int line, char const* fmt, ...);

/**
 * @brief Macro for logging info messages.
 * @param[in] fmt printf-style format string.
 * @param[in] ... Arguments for the format string.
 */
#define TRIBO_LOG(fmt, ...) triboLog(TRIBO_LOG_INFO, __FILE__, __func__, __LINE__, fmt, __VA_ARGS__)

/**
 * @brief Macro for logging error messages.
 * @param[in] fmt printf-style format string.
 * @param[in] ... Arguments for the format string.
 */
#define TRIBO_ERROR(fmt, ...) triboLog(TRIBO_LOG_ERROR, __FILE__, __func__, __LINE__, fmt, __VA_ARGS__)
