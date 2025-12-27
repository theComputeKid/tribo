/**
 * @file
 * @brief Holds the state of one instance of the solver.
 */
#pragma once
#include <cstddef>

namespace tribo {

  struct Config {
    // Domain
    std::size_t nx = 32; // Grid points in x-direction
    std::size_t ny = 32; // Grid points in y-direction

    double xin = -3.0; // Inlet x-coordinate
    double xout = 3.0; // Outlet x-coordinate
    double yin = -3.0; // Inlet y-coordinate
    double yout = 3.0; // Outlet y-coordinate

    // Moes params.
    double moes_m = 8;         // Moes M parameter
    double moes_l = 0.0;       // Moes L parameter
    double initial_h0 = -1e-6; // Initial guess for H0

    // Relaxation parameters.
    double eps = 0.5;       // Value that determines b/w jacobi and gs relaxation
    double relax_jac = 0.8; // Jacobi relaxation factor
    double relax_gs = 1.0;  // Gauss-Seidel relaxation factor
    double relax_h0 = 0.7;  // Relaxation factor for h0

    // Multigrid parameters.
    std::size_t mgl = 3;         // Number of multigrid levels
    std::size_t num_cycles = 10; // Maximum number of complete cycles to run
    std::size_t it_pre = 2;      // Number of pre-smoothing iterations
    std::size_t it_main = 4;     // Number of main iterations
    std::size_t it_post = 2;     // Number of post-smoothing iterations
    std::size_t gamma = 2;       // Coarsening factor (2 for V-cycle, 3 for W-cycle)

    // Tolerance.
    double tol_p = 1e-6;  // Pressure tolerance
    double tol_h = 1e-6;  // Film thickness tolerance
    double tol_fb = 1e-6; // Force balance tolerance

    bool valid = true; // Set last to non-zero if config is valid.
  };

  struct Results {
    double* p;
    double* h;
    int valid;
  };

  auto solveBase(Config const& config) -> Results;
  auto solveAVX(Config const& config) -> Results;
  auto solveNEON(Config const& config) -> Results;
  auto solveCUDA(Config const& config) -> Results;

  auto displayVersionMajor() -> unsigned int;

  auto displayVersionMinor() -> unsigned int;

  auto displayVersionPatch() -> unsigned int;
  auto displayVersion() -> void;
} // namespace tribo

// TriboResults triboSolveAVX(TriboConfig const& config);
// TriboResults triboSolveAVX512(TriboConfig const& config);

// TriboResults triboSolveNEON(TriboConfig const& config);
// TriboResults triboSolveSVE2(TriboConfig const& config);
