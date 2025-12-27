/**
 * @file time.h
 * @brief Timing functions.
 */
#pragma once
#include "export.h"

/** @brief Opaque pointer to timer structure. */
typedef struct TriboUtilsTime TriboUtilsTime;

/**
 * @brief Start a new timer. Must be freed with triboUtilsTimeStopAndFree().
 *
 * @return Opaque pointer to timer structure.
 */
TRIBO_UTILS_LINK TriboUtilsTime* triboUtilsTimeStart(void);
/**
 * @brief Stop the timer, return elapsed time in milliseconds, and free the timer.
 *
 * @param[in] t Pointer to the timer to stop and free.
 * @return Elapsed time in milliseconds.
 */
TRIBO_UTILS_LINK double triboUtilsTimeStopAndFree(TriboUtilsTime** t);
