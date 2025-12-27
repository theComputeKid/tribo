#include "tribo/time.h"
#include <stdlib.h>
#include <time.h>

static double iTimerElapsedMs(struct timespec start, struct timespec end) {
  double seconds = (double)(end.tv_sec - start.tv_sec);
  double nanoseconds = (double)(end.tv_nsec - start.tv_nsec);
  double elapsed = (seconds * 1000.0) + (nanoseconds / 1000000.0);
  return elapsed;
}

TriboUtilsTime* triboUtilsTimeStart(void) {
  struct timespec* t = malloc(sizeof(struct timespec));
  (void)timespec_get(t, TIME_UTC);
  return (TriboUtilsTime*)t;
}

double triboUtilsTimeStopAndFree(TriboUtilsTime** t) {
  struct timespec end;
  (void)timespec_get(&end, TIME_UTC);
  double const elapsed = iTimerElapsedMs(*(struct timespec*)*t, end);
  free((struct timespec*)*t);
  *t = NULL;
  return elapsed;
}
