#pragma once
#include "triboExport.h"
#include <stddef.h>

/**
 * @brief Get the current high-resolution wall-clock time in seconds.
 *
 * @return Current high-resolution wall-clock time in seconds.
 */
TRIBO_UTILS_LINK double triboUtilsGetTime(void);

/** @brief Return true if AVX2 is supported */
TRIBO_UTILS_LINK int triboUtilsIsaDetectAVX2(void);

/** @brief Return true if AVX512 is supported */
TRIBO_UTILS_LINK int triboUtilsIsaDetectAVX512(void);

/** @brief Return true if NEON is supported */
TRIBO_UTILS_LINK int triboUtilsIsaDetectNEON(void);

/** @brief Return true if SVE2 is supported */
TRIBO_UTILS_LINK int triboUtilsIsaDetectSVE2(void);

/**
 * @brief Searches for prefix in the input string.
 *
 * @param input Input string to search. Must be null terminated.
 * @param prefix Prefix to search for. Must be null terminated.
 * @return -1 if not found. 0 otherwise.
 */
TRIBO_UTILS_LINK int triboUtilsParseFlag(char const* input, char const* prefix);

/**
 * @brief Searches for prefix in the input string, and returns a pointer to the rest of the string.
 *
 * @param[in] input Input string to search. Must be null terminated.
 * @param[in] prefix Prefix to search for. Must be null terminated.
 * @param[out] out Pointer to the rest of the string after the prefix is found.
 * @return -1 if not found. 0 otherwise.
 */
TRIBO_UTILS_LINK int triboUtilsParseString(char const* input, char const* prefix, char const** out);

/**
 * @brief Searches for prefix in the input string, and parses an unsigned int from the rest of the string.
 *
 * @param[in] input Input string to search. Must be null terminated.
 * @param[in] prefix Prefix to search for. Must be null terminated.
 * @param[out] out Parsed unsigned int value.
 * @return -1 if not found or parsing failed. 0 otherwise.
 */
TRIBO_UTILS_LINK int triboUtilsParseUInt(char const* input, char const* prefix, unsigned int* out);

/**
 * @brief Searches for prefix in the input string, and parses a double from the rest of the string.
 *
 * @param[in] input Input string to search. Must be null terminated.
 * @param[in] prefix Prefix to search for. Must be null terminated.
 * @param[out] out Parsed double value.
 * @return -1 if not found or parsing failed. 0 otherwise.
 */
TRIBO_UTILS_LINK int triboUtilsParseDouble(char const* input, char const* prefix, double* out);

/** @brief Output of the INI parser. */
typedef struct {

  // Domain
  size_t nx; // Grid points in x-direction
  size_t ny; // Grid points in y-direction

  double xin;  // Inlet x-coordinate
  double xout; // Outlet x-coordinate
  double yin;  // Inlet y-coordinate
  double yout; // Outlet y-coordinate

  // Moes params.
  double moes_m;     // Moes M parameter
  double moes_l;     // Moes L parameter
  double initial_h0; // Initial guess for H0

  // Relaxation parameters.
  double eps;       // Value that determines b/w jacobi and gs relaxation
  double relax_jac; // Jacobi relaxation factor
  double relax_gs;  // Gauss-Seidel relaxation factor
  double relax_h0;  // Relaxation factor for h0

  // Multigrid parameters.
  size_t mgl;        // Number of multigrid levels
  size_t num_cycles; // Maximum number of complete cycles to run
  size_t it_pre;     // Number of pre-smoothing iterations
  size_t it_main;    // Number of main iterations
  size_t it_post;    // Number of post-smoothing iterations
  size_t gamma;      // Coarsening factor (2 for V-cycle, 3 for W-cycle)

  // Tolerance.
  double tol_p;  // Pressure tolerance
  double tol_h;  // Film thickness tolerance
  double tol_fb; // Force balance tolerance

} TriboUtilsIniConfig;

/**
 * @brief Parse an INI file into a configuration structure. Returns default values if no file is provided.
 *
 * Reads line by line, ignoring comments (lines starting with #) and empty lines. Each line is expected to be in the
 * format "parameter=value". Maximum line length is 32 characters.
 *
 * @param[in] inputFilePath Path to the INI file. Set NULL to use default values.
 * @param[out] config Parsed configuration structure.
 * @return -1 if parsing failed. 0 otherwise.
 */
TRIBO_UTILS_LINK int triboUtilsParseConfig(char const* inputFilePath, TriboUtilsIniConfig* config);

/** @brief Contains symbols loaded at runtime. */
typedef struct {
  void* library;
  triboSolve* Solve;
  triboFree* Free;
} TriboUtilsPlugin;

TRIBO_UTILS_LINK int triboUtilsPluginUnload(TriboUtilsPlugin* p);
TRIBO_UTILS_LINK int triboUtilsPluginLoadFromPath(char const* const path, TriboUtilsPlugin* p);
