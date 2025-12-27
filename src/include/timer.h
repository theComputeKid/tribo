/**
 * @file
 * @brief Timer helpers.
 */
#pragma once
#include <time.h>

struct timespec triboTimerStart(void);
double triboTimerStop(struct timespec const* start);
