/**
 * @file parse.h
 * @brief Parsing functions.
 */
#pragma once
#include "export.h"

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
  unsigned int nx; // Grid points in x-direction
  unsigned int ny; // Grid points in y-direction

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
  unsigned int mgl;        // Number of multigrid levels
  unsigned int num_cycles; // Maximum number of complete cycles to run
  unsigned int it_pre;     // Number of pre-smoothing iterations
  unsigned int it_main;    // Number of main iterations
  unsigned int it_post;    // Number of post-smoothing iterations
  unsigned int gamma;      // Coarsening factor (2 for V-cycle, 3 for W-cycle)

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
