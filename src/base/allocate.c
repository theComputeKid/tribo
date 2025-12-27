#include "solver.h"
#include "tribo/log.h"
#include "tribo/parse.h"
#include <stddef.h>
#include <stdlib.h>

static int iAllocateLevel(TriboLevel* const level) {

  size_t const nxy = level->nx * level->ny;

  // Allocate memory.
  level->p = calloc(nxy, sizeof(double));
  if (!level->p) {
    return -1;
  }

  level->p_rhs = calloc(nxy, sizeof(double));
  if (!level->p_rhs) {
    return -1;
  }

  level->p_old = calloc(nxy, sizeof(double));
  if (!level->p_old) {
    return -1;
  }

  level->h = calloc(nxy, sizeof(double));
  if (!level->h) {
    return -1;
  }

  return 0;
}

int triboAllocate(TriboSolver* const solver) {

  TRIBO_LOG_INFO("%s", "Allocating solver workspace.");
  solver->levels = calloc(solver->config->mgl, sizeof(TriboLevel));
  if (!solver->levels) {
    return -1;
  }

  // Grid refinement scheme. We want to maintain power of two grid sizes so we
  // must adjust the domain boundaries at every level. E.g.:
  //  0 1 2 3 4 5 6 7  nx = 8 dx = 1 xin = 0.0 xout = 7.0 l = 3
  // |.|.|.|.|.|.|.|.|
  //  0.5 2.5 4.5 6.5  nx = 4 dx = 2 xin = 0.5 xout = 6.5 l = 2
  // | . | . | . | . |
  //    1.5     5.5    nx = 2 dx = 4 xin = 1.5 xout = 5.5 l = 1
  // |   .   |   .   |
  //        3.5        nx = 1 dx = 8 xin = 3.5 xout = 3.5 l = 0
  // |       .       |

  // Finest grid params provided as input. Start from here.
  size_t const max_level = solver->config->mgl - 1;

  solver->levels[max_level].nx = solver->config->nx;
  solver->levels[max_level].ny = solver->config->ny;

  solver->levels[max_level].xin = solver->config->xin;
  solver->levels[max_level].yin = solver->config->yin;
  solver->levels[max_level].xout = solver->config->xout;
  solver->levels[max_level].yout = solver->config->yout;

  solver->levels[max_level].dx =
      (solver->levels[max_level].xout - solver->levels[max_level].xin) / (double)(solver->levels[max_level].nx - 1);
  solver->levels[max_level].dy =
      (solver->levels[max_level].yout - solver->levels[max_level].yin) / (double)(solver->levels[max_level].ny - 1);

  TRIBO_LOG_INFO("Allocating memory for level: %zu", max_level);
  if (iAllocateLevel(&solver->levels[max_level])) {
    return -1;
  }

  // Go top down.
  for (size_t l = max_level - 1; l != (size_t)-1; --l) {

    TRIBO_LOG_INFO("Allocating memory for level: %zu", l);

    // Grid points half every level down.
    solver->levels[l].nx = solver->levels[l + 1].nx >> 1;
    solver->levels[l].ny = solver->levels[l + 1].ny >> 1;

    // Grid spacing doubles every level down.
    solver->levels[l].dx = solver->levels[l + 1].dx * 2.0;
    solver->levels[l].dy = solver->levels[l + 1].dy * 2.0;

    // Shift boundaries so we can maintain power of two grid sizes. Both
    // boundaries move closer to the centre.

    // Inlet moves towards the right.
    solver->levels[l].xin = solver->levels[l + 1].xin + (solver->levels[l].dx * 0.25);
    solver->levels[l].yin = solver->levels[l + 1].yin + (solver->levels[l].dy * 0.25);

    // Outlet moves towards the left.
    solver->levels[l].xout = solver->levels[l + 1].xout - (solver->levels[l].dx * 0.25);
    solver->levels[l].yout = solver->levels[l + 1].yout - (solver->levels[l].dy * 0.25);

    if (iAllocateLevel(&solver->levels[l])) {
      return -1;
    }
  }
  TRIBO_LOG_INFO("%s", "Successfully allocated memory for all levels");
  return 0;
}

size_t triboGetMemoryEstimate(TriboUtilsIniConfig const* const config) {

  size_t bytes = sizeof(TriboSolver);        // Solver struct itself.
  bytes += config->mgl * sizeof(TriboLevel); // Level pointer allocation.

  for (size_t l = 0; l < config->mgl; l++) {
    size_t const nx = config->nx * (1u << l);
    size_t const ny = config->ny * (1u << l);
    size_t const nxy = nx * ny;

    // Memory required for each level allocation.
    bytes += nxy * sizeof(double); // p
    bytes += nxy * sizeof(double); // p_rhs
    bytes += nxy * sizeof(double); // p_old
    bytes += nxy * sizeof(double); // h
  }

  return bytes;
}

int triboLogDomainInfo(TriboSolver const* const solver) {

  // Check if levels are allocated. Otherwise there is nothing to show.
  if (!solver->levels) {
    return 1;
  }

  for (size_t l = 0; l < solver->config->mgl; l++) {
    TRIBO_LOG_INFO("MultiGrid Level: %zu", l);

    TRIBO_LOG_INFO("nx: %zu", solver->levels[l].nx);
    TRIBO_LOG_INFO("ny: %zu", solver->levels[l].ny);

    TRIBO_LOG_INFO("dx: %.2e", solver->levels[l].dx);
    TRIBO_LOG_INFO("dy: %.2e", solver->levels[l].dy);
    TRIBO_LOG_INFO("xin: %.2e", solver->levels[l].xin);
    TRIBO_LOG_INFO("yin: %.2e", solver->levels[l].yin);

    TRIBO_LOG_INFO("xout: %.2e", solver->levels[l].xout);
    TRIBO_LOG_INFO("yout: %.2e", solver->levels[l].yout);
  }
  return 0;
}
