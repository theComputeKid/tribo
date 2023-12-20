/**
 * @file
 * @brief Public C interface for the tribo library.
 *
 * @copyright Copyright (c) 2023 theComputeKid
 */
#pragma once
#ifdef __cplusplus
/** @brief Macro for enabling/disabling extern linkage. */
#	define TRIBO_EXTERN_C extern "C"
#else
/** @brief Macro for enabling/disabling extern linkage. */
#	define TRIBO_EXTERN_C
#endif

#ifdef _WIN32
#	ifdef TRIBO_EXPORT_API
/** @brief Macro for exporting symbols for Windows. */
#		define TRIBO_LINK TRIBO_EXTERN_C __declspec(dllexport)
#	else
/** @brief Macro for importing symbols for Windows. */
#		define TRIBO_LINK TRIBO_EXTERN_C __declspec(dllimport)
#	endif
#else
#	ifdef TRIBO_EXPORT_API
/** @brief Macro for exporting symbols for Unix. */
#		define TRIBO_LINK TRIBO_EXTERN_C __attribute__((visibility("default")))
#	else
/** @brief Macro for importing symbols for Unix. Empty. */
#		define TRIBO_LINK TRIBO_EXTERN_C
#	endif
#endif

/**
 * @brief Return the major version of the tribo project.
 *
 * @return the major version of the project.
 */
TRIBO_LINK int triboInfoVersionMajor(void);

/**
 * @brief Return the minor version of the tribo project.
 *
 * @return the minor version of the project.
 */
TRIBO_LINK int triboInfoVersionMinor(void);

/**
 * @brief Return the patch version of the tribo project.
 *
 * @return the patch version of the project.
 */
TRIBO_LINK int triboInfoVersionPatch(void);
