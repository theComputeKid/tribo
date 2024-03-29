# * Main project file.
cmake_minimum_required(VERSION 3.28)

project(
  tribo
  VERSION 0.0.1
  DESCRIPTION "a point contact lubrication solver"
  LANGUAGES C CXX
)

# * List of project options.
option(TRIBO_ENABLE_WARNINGS "Enable warnings during compilation." OFF)
option(TRIBO_USE_PCH "Use PCH during compilation." OFF)
option(TRIBO_USE_LIBCXX "Build with LLVM's libc++." OFF)
option(TRIBO_ENABLE_DOC "Enable doxygen documentation generation." OFF)
option(TRIBO_ENABLE_TESTS "Enable tests." OFF)
option(TRIBO_ENABLE_CODECOVERAGE "Enable code coverage generation in debug config." OFF)
option(TRIBO_ENABLE_SANITIZERS "Enable sanitizers in debug config." OFF)
option(TRIBO_EXPORT_COMPILE_COMMANDS "Enable compile_commands.json generation." OFF)

set(
  CMAKE_CONFIGURATION_TYPES "Debug;Release;Dist"
  CACHE STRING "Allowed project configurations" FORCE
)

# * Load project configuration.
include(${CMAKE_CURRENT_SOURCE_DIR}/scripts/cmake/config.cmake)

add_subdirectory(src)

if(TRIBO_ENABLE_TESTS)
  add_subdirectory(test)
  add_subdirectory(bench)
endif()

if(PROJECT_IS_TOP_LEVEL)
  include(CPack)
endif()
