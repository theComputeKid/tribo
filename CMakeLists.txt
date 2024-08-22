# * Main project file.
cmake_minimum_required(VERSION 3.30)

project(
  tribo
  VERSION 0.0.1
  DESCRIPTION "the solution to all your tribological needs"
  LANGUAGES C CXX
)

# * List of project options.
option(TRIBO_ENABLE_WARNINGS "Enable warnings during compilation." OFF)
option(TRIBO_USE_PCH "Use PCH during compilation." OFF)
option(TRIBO_USE_LIBCXX "Build with LLVM's libc++." OFF)
option(TRIBO_ENABLE_BENCH "Enable performance tests." OFF)
option(TRIBO_ENABLE_CODECOVERAGE "Enable code coverage generation in debug config." OFF)
option(TRIBO_ENABLE_DOC "Enable doxygen documentation generation." OFF)
option(TRIBO_ENABLE_SANITIZERS "Enable sanitizers in debug config." OFF)
option(TRIBO_ENABLE_TESTS "Enable correctness tests." OFF)
option(TRIBO_EXPORT_COMPILE_COMMANDS "Enable compile_commands.json generation." OFF)

# * Load project configuration.
include(${CMAKE_CURRENT_SOURCE_DIR}/tools/cmake/config.cmake)

# * Load subprojects.
add_subdirectory(src)

if(TRIBO_ENABLE_TESTS)
  add_subdirectory(test)
endif()

if(TRIBO_ENABLE_BENCH)
  add_subdirectory(bench)
endif()
