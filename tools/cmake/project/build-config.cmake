# * For multiconfig generators, we only do debug and release builds.
if(CMAKE_CONFIGURATION_TYPES)
  set(
    CMAKE_CONFIGURATION_TYPES "Release;Debug"
    CACHE STRING "Allowed project configurations" FORCE
  )

# * Default for single config build system is release.
elseif(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release")
  message("CMAKE_BUILD_TYPE not specified. Assuming Release.")

# * Single config generators are restricted to debug and release builds.
elseif(NOT CMAKE_BUILD_TYPE STREQUAL "Debug" AND NOT CMAKE_BUILD_TYPE STREQUAL "Release")
  message(FATAL_ERROR "Only Debug and Release build configurations are supported.")
endif()
