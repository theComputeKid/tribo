#pragma once
#include "export.h"
#include "parse.h"

/** @brief Data to write into output results file. */
typedef struct {

  // Results
  double* p;
  double* h;

  // Domain
  unsigned int nx; // Grid points in x-direction
  unsigned int ny; // Grid points in y-direction

} TriboUtilsResults;

/** @brief Function arguments taken by the backend solvers.*/
#define TRIBO_BACKEND_ARGS TriboUtilsResults *results, TriboUtilsIniConfig const *config

/** @brief Convenience typedef for function type of backend solver.*/
typedef int triboSolveFunc(TRIBO_BACKEND_ARGS);

/**
 * @brief Function that the backends must implement.
 *
 * @param[out] results
 * @param[in] config
 * @return 0 on success, non-zero on failure.
 */
TRIBO_LINK int triboSolve(TRIBO_BACKEND_ARGS);

typedef struct {
  void* handle;
  triboSolveFunc* solver;
} TriboUtilsPlugin;

/**
 * @brief Loads a plugin from the specified path. If the path is NULL,
 * it attempts to load the best available plugin based on the current architecture.
 *
 * @param[in] path Path to the plugin file. Can be NULL for automatic selection.
 * @param[out] handle Pointer to store the plugin handle.
 * @return 0 on success, non-zero on failure.
 */
TRIBO_UTILS_LINK int triboUtilsPluginLoadFromPath(char const* path, TriboUtilsPlugin* handle);

/**
 * @brief Solves the tribology problem using the specified plugin.
 *
 * @param[out] results
 * @param[in] config
 * @param[in] handle
 * @return 0 on success, non-zero on failure.
 */
TRIBO_UTILS_LINK int
triboUtilsPluginSolve(TriboUtilsResults* results, TriboUtilsIniConfig const* config, TriboUtilsPlugin* handle);

/**
 * @brief Unloads the specified plugin.
 *
 * @param[in] handle Plugin handle to unload.
 * @return 0 on success, non-zero on failure.
 */
TRIBO_UTILS_LINK int triboUtilsPluginUnload(TriboUtilsPlugin* handle);
