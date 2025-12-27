#include "solver.h"
#include <math.h>
#include <stddef.h>

// Returns the square of the distance to the centre of the grid cell.
static inline double triboGetGridPosition(double const in, double const idx, double const delta) {
  double const out = in + (idx * delta);
  return out * out;
}

static void triboInitLevel(TriboLevel* restrict const level) {
  level->fb = 0.0;

  for (size_t j = 0; j < level->ny; j++) {
    double const y2 = triboGetGridPosition(level->yin, (double)j, level->dy);
    for (size_t i = 0; i < level->nx; i++) {
      size_t const idx = (j * level->nx) + i;
      double const x2 = triboGetGridPosition(level->xin, (double)i, level->dx);
      double const value = x2 + y2;
      level->h[idx] = 0.5 * value;
      if (value < 1.0) {
        level->p[idx] = sqrt(1.0 - value);
      }
    }
  }
}

int triboInit(TriboSolver* const solver) {

  for (size_t l = 0; l < solver->config->mgl; l++) {
    triboInitLevel(&solver->levels[l]);
  }

  return 0;
}
