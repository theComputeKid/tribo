#include "solver.h"
#include "tribo/log.h"
#include "tribo/parse.h"
#include "tribo/plugin.h"
#include <stddef.h>

static void iLogMemory(TriboUtilsIniConfig const* const config) {
  size_t const bytes = triboGetMemoryEstimate(config);
  TRIBO_LOG_INFO("Estimated memory requirements: %zu Bytes, %.2f KB, %.2f MB, %.2f GB",
                 bytes,
                 (double)bytes / 1024.0,
                 (double)bytes / (1024.0 * 1024.0),
                 (double)bytes / (1024.0 * 1024.0 * 1024.0));
}

int triboSolve(TRIBO_BACKEND_ARGS) {

  TRIBO_LOG_INFO("%s", "Entering solver.");
  iLogMemory(config);

  TriboSolver solver = {.config = config};

  if (triboAllocate(&solver)) {
    TRIBO_LOG_ERROR("%s", "Unable to allocate solver workspace.");
    return -1;
  }

  triboLogDomainInfo(&solver);

  if (triboInit(&solver)) {
    TRIBO_LOG_ERROR("%s", "Unable to initialize solver workspace.");
    return -1;
  }

  (void)results;
  return 0;
}
