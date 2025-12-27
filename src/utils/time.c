#define TRIBO_UTILS_EXPORT
#include "triboUtils.h"

#if defined(_WIN32)

#  include <windows.h>
/**
 * triboUtilsGetTime
 *
 * Returns the current high-resolution wall-clock time in seconds.
 *
 * This function uses QueryPerformanceCounter and QueryPerformanceFrequency to
 * compute a floating-point time value. The return value is the number of
 * seconds (including fractional part) since an arbitrary reference point
 * (implementation-defined, commonly system boot). It is intended for measuring
 * elapsed time and not for obtaining the current date/time-of-day.
 *
 * Units:
 *   - seconds (double, fractional seconds)
 *
 * Notes:
 *   - The resolution and precision depend on the underlying performance counter
 *     frequency.
 *   - The value is suitable for interval timing (monotonic on modern Windows),
 *     but should not be treated as a calendar timestamp.
 *
 * Returns:
 *   double - current time in seconds.
 */

double triboUtilsGetTime(void) {
  LARGE_INTEGER t, f;
  QueryPerformanceCounter(&t);
  QueryPerformanceFrequency(&f);
  return ((double)t.QuadPart / (double)f.QuadPart);
}

#else

#  include <sys/resource.h>
#  include <sys/time.h>

/**
 * triboUtilsGetTime
 *
 * Returns the current wall-clock time in seconds.
 *
 * This function uses gettimeofday to obtain the current time with
 * microsecond precision. The return value is the number of seconds
 * (including fractional part) since the Unix epoch (January 1, 1970).
 *
 * Units:
 *   - seconds (double, fractional seconds)
 *
 * Notes:
 *   - The resolution is typically microseconds, but may vary by system.
 *   - The value represents calendar time and can be converted to date/time.
 *
 * Returns:
 *   double - current time in seconds since the Unix epoch.
 */
double triboUtilsGetTime(void) {
  // struct timeval t;
  // struct timezone tzp;
  // gettimeofday(&t, &tzp);
  // return t.tv_sec + t.tv_usec * 1e-6;
  return 0;
}

#endif
