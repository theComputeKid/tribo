#pragma once

/** @brief Convenience architecture macros. */
#if defined(__x86_64__) && (defined(__clang__) || defined(__GNUC__)) && defined(_WIN32)
#  define TRIBO_X64_GCC_CLANG
#  define TRIBO_X64_WINDOWS
#  define TRIBO_X64
#elif defined(__aarch64__) && (defined(__clang__) || defined(__GNUC__)) && defined(_WIN32)
#  define TRIBO_ARM64_GCC_CLANG
#  define TRIBO_ARM64_WINDOWS
#  define TRIBO_ARM64
#elif defined(_M_X64) && defined(_MSC_VER)
#  define TRIBO_X64_MSVC
#  define TRIBO_X64_WINDOWS
#  define TRIBO_X64
#elif defined(_M_ARM64) && defined(_MSC_VER)
#  define TRIBO_ARM64_MSVC
#  define TRIBO_ARM64_WINDOWS
#  define TRIBO_ARM64
#elif defined(__x86_64__) && defined(__linux__)
#  define TRIBO_X64_LINUX
#  define TRIBO_X64
#elif defined(__aarch64__) && defined(__linux__)
#  define TRIBO_ARM64_LINUX
#  define TRIBO_ARM64
#elif defined(__aarch64__) && defined(__APPLE__)
#  define TRIBO_ARM64_MACOS
#  define TRIBO_ARM64
#endif
