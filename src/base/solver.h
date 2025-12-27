/**
 * @file
 * @brief Internal data structures for the solver.
 */
#pragma once
#include "tribo/parse.h"
#include <stddef.h>

/** @brief Workspace for a single level in the multigrid hierarchy. */
typedef struct {
  size_t nx;
  size_t ny;
  double dx;
  double dy;
  double fb; // Force balance
  double* p;
  double* p_rhs;
  double* p_old;
  double* h;
  double xin;
  double xout;
  double yin;
  double yout;
  unsigned int level;
} TriboLevel;

/** @brief Overall workspace for the solver. */
typedef struct {
  TriboLevel* levels;
  TriboUtilsIniConfig const* config;
} TriboSolver;

/** @brief Get an estimate of the memory required for the solver. */
size_t triboGetMemoryEstimate(TriboUtilsIniConfig const* config);

/** @brief Allocate memory for the solver workspace. */
int triboAllocate(TriboSolver* const solver);

/** @brief Log information about the solver domain. */
int triboLogDomainInfo(TriboSolver const* const solver);

/** @brief Initialize the solver workspace. */
int triboInit(TriboSolver* const solver);
