/**
 * @file
 * @brief Holds the state of one instance of the solver.
 */
#pragma once
#include <stddef.h>

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

  int valid; // Set last to non-zero if config is valid.

} TriboConfig;

typedef struct {
  double* p;
  double* h;
  int valid;
} TriboResults;

TriboResults triboSolveBase(TriboConfig const* config);

TriboResults triboSolveAVX(TriboConfig const* config);
TriboResults triboSolveAVX512(TriboConfig const* config);

TriboResults triboSolveNEON(TriboConfig const* config);
TriboResults triboSolveSVE2(TriboConfig const* config);
