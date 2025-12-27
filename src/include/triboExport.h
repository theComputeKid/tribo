#pragma once
#include <stddef.h>

/** @brief Export a C interface even when compiling with C++. */
#ifdef __cplusplus
/** @brief Macro for enabling/disabling extern linkage. */
#  define TRIBO_EXTERN_C extern "C"
#else
/** @brief Macro for enabling/disabling extern linkage. */
#  define TRIBO_EXTERN_C
#endif

/** @brief Utils should define TRIBO_UTILS_EXPORT for symbol exports. */
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

/** @brief Plugins should define TRIBO_PLUGINS_EXPORT for symbol exports. */
#ifdef _WIN32
#  ifdef TRIBO_PLUGINS_EXPORT
/** @brief Macro for exporting symbols for Windows. */
#    define TRIBO_PLUGINS_LINK TRIBO_EXTERN_C __declspec(dllexport)
#  else
/** @brief Declare a typedef for importing the function at runtime. */
#    define TRIBO_PLUGINS_LINK typedef
#  endif
#else
#  ifdef TRIBO_PLUGINS_EXPORT
/** @brief Macro for exporting symbols for Unix. */
#    define TRIBO_PLUGINS_LINK TRIBO_EXTERN_C __attribute__((visibility("default")))
#  else
/** @brief Declare a typedef for importing the function at runtime. */
#    define TRIBO_PLUGINS_LINK TRIBO_EXTERN_C typedef
#  endif
#endif

/** @brief Solves for the given inputs and places results in the output pointers. */
TRIBO_PLUGINS_LINK int triboSolve(

    // Domain
    size_t nx,   // Grid points in x-direction
    size_t ny,   // Grid points in y-direction
    double xin,  // Inlet x-coordinate
    double xout, // Outlet x-coordinate
    double yin,  // Inlet y-coordinate
    double yout, // Outlet y-coordinate

    // Moes.
    double moes_m,     // Moes M parameter
    double moes_l,     // Moes L parameter
    double initial_h0, // Initial guess for H0

    // Relaxation.
    double eps,       // Value that determines b/w jacobi and gs relaxation
    double relax_jac, // Jacobi relaxation factor
    double relax_gs,  // Gauss-Seidel relaxation factor
    double relax_h0,  // Relaxation factor for h0

    // Multigrid parameters.
    size_t mgl,        // Number of multigrid levels
    size_t num_cycles, // Maximum number of complete cycles to run
    size_t it_pre,     // Number of pre-smoothing iterations
    size_t it_main,    // Number of main iterations
    size_t it_post,    // Number of post-smoothing iterations
    size_t gamma,      // Coarsening factor (2 for V-cycle, 3 for W-cycle)

    // Tolerance.
    double tol_p,  // Pressure tolerance
    double tol_h,  // Film thickness tolerance
    double tol_fb, // Force balance tolerance

    // Outputs.
    // These are allocated internally by the plugins and are of size nx*ny.
    // Free after use with triboFree.
    double** p, // Pressure results
    double** h  // Film thickness results
);

TRIBO_PLUGINS_LINK void triboFree(double** p, double** h);
