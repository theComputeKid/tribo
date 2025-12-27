#pragma once

/** @brief Export a C interface even when compiling with C++. */
#ifdef __cplusplus
/** @brief Macro for enabling/disabling extern linkage. */
#  define TRIBO_EXTERN_C extern "C"
#else
/** @brief Macro for enabling/disabling extern linkage. */
#  define TRIBO_EXTERN_C
#endif

/** @brief Only UTILS should define TRIBO_UTILS_EXPORT for symbol exports. */
#ifdef _WIN32
#  ifdef TRIBO_UTILS_EXPORT
/** @brief Macro for exporting symbols for Windows. */
#    define TRIBO_UTILS_LINK TRIBO_EXTERN_C __declspec(dllexport)
#  else
/** @brief Macro for importing symbols for Windows. */
#    define TRIBO_UTILS_LINK TRIBO_EXTERN_C __declspec(dllimport)
#  endif
#else
#  ifdef TRIBO_UTILS_EXPORT
/** @brief Macro for exporting symbols for Unix. */
#    define TRIBO_UTILS_LINK TRIBO_EXTERN_C __attribute__((visibility("default")))
#  else
/** @brief Macro for importing symbols for Unix. Empty. */
#    define TRIBO_UTILS_LINK TRIBO_EXTERN_C
#  endif
#endif

/** @brief Plugins should define TRIBO_EXPORT for symbol exports. */
#ifdef _WIN32
#  ifdef TRIBO_EXPORT
/** @brief Macro for exporting symbols for Windows. */
#    define TRIBO_LINK TRIBO_EXTERN_C __declspec(dllexport)
#  else
/** @brief Macro for importing symbols for Windows. */
#    define TRIBO_LINK TRIBO_EXTERN_C __declspec(dllimport)
#  endif
#else
#  ifdef TRIBO_EXPORT
/** @brief Macro for exporting symbols for Unix. */
#    define TRIBO_LINK TRIBO_EXTERN_C __attribute__((visibility("default")))
#  else
/** @brief Macro for importing symbols for Unix. Empty. */
#    define TRIBO_LINK TRIBO_EXTERN_C
#  endif
#endif
