# * Main project CMakeLists.txt file.

# * CMake 3.28 required due to:
# * Schema field in CMakePresets.json (v8).
# * C++20 module support.
# * FetchContent EXCLUDE_FROM_ALL.
cmake_minimum_required(VERSION 3.28)

project(
  tribo
  VERSION 0.0.1
  DESCRIPTION "a point contact lubrication solver"
  LANGUAGES C CXX
)

# * Set the cmake tools directory.
set(TRIBO_CMAKE_SCRIPTS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/scripts/cmake)

# * Project CMake configuration options.
include(${TRIBO_CMAKE_SCRIPTS_DIR}/options.cmake)
include(${TRIBO_CMAKE_SCRIPTS_DIR}/project.cmake)
include(${TRIBO_CMAKE_SCRIPTS_DIR}/3p.cmake)
include(${TRIBO_CMAKE_SCRIPTS_DIR}/rules.cmake)

add_subdirectory(src)

if(TRIBO_ENABLE_TESTS)
  add_subdirectory(test)
endif(TRIBO_ENABLE_TESTS)
