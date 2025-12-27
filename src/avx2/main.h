#pragma once
#include <immintrin.h>
#include <stddef.h>

/** @brief Data required for performing operations on a single multigrid level. */
typedef struct {

  __m256d* p; // Pressure values
  __m256d* h; // Film thickness values

  __m256d* p_rhs;
  __m256d* p_old;

  double fb;

  size_t nx; // Grid points in x-direction
  size_t ny; // Grid points in y-direction

  double xin;  // Inlet x-coordinate
  double xout; // Outlet x-coordinate
  double yin;  // Inlet y-coordinate
  double yout; // Outlet y-coordinate

} TriboLevel;

typedef struct {

  TriboLevel* levels; // Multigrid levels

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

  // Results
  double* p; // Pressure values
  double* h; // Film thickness values

} TriboSolver;
