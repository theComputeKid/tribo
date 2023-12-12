/**
 * @brief Public C interface for the tribo library.
 *
 * @copyright Copyright (c) 2023 theComputeKid
 */
#pragma once
#ifdef __cplusplus
#	define TRIBO_EXTERN_C extern "C"
#else
#	define TRIBO_EXTERN_C
#endif

#ifdef _WIN32
#	ifdef TRIBO_EXPORT_API
#		define TRIBO_LINK TRIBO_EXTERN_C __declspec(dllexport)
#	else
#		define TRIBO_LINK TRIBO_EXTERN_C __declspec(dllimport)
#	endif
#else
#	ifdef TRIBO_EXPORT_API
#		define TRIBO_LINK TRIBO_EXTERN_C __attribute__((visibility("default")))
#	else
#		define TRIBO_LINK TRIBO_EXTERN_C
#	endif
#endif

TRIBO_LINK int triboInfoVersionMajor(void);

TRIBO_LINK int triboInfoVersionMinor(void);

TRIBO_LINK int triboInfoVersionPatch(void);
