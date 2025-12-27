#define TRIBO_PLUGINS_EXPORT
#include "main.h"
#include "triboExport.h"

int triboSolve(

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
) {
  TriboSolver solver = {.nx = nx,
                        .ny = ny,
                        .xin = xin,
                        .xout = xout,
                        .yin = yin,
                        .yout = yout,
                        .moes_m = moes_m,
                        .moes_l = moes_l,
                        .initial_h0 = initial_h0,
                        .eps = eps,
                        .relax_jac = relax_jac,
                        .relax_gs = relax_gs,
                        .relax_h0 = relax_h0,
                        .mgl = mgl,
                        .num_cycles = num_cycles,
                        .it_pre = it_pre,
                        .it_main = it_main,
                        .it_post = it_post,
                        .gamma = gamma,
                        .tol_p = tol_p,
                        .tol_h = tol_h,
                        .tol_fb = tol_fb,
                        .p = NULL,
                        .h = NULL};
  *p = solver.p;
  *h = solver.h;
  return 0;
}

void triboFree(double** p, double** h) {

  if (p && *p) {
    free(*p);
    *p = NULL;
  }

  if (h && *h) {
    free(*h);
    *h = NULL;
  }
}
