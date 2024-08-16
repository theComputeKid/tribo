# * Main project file.
cmake_minimum_required(VERSION 3.30)

project(
  tribo
  VERSION 0.0.1
  DESCRIPTION "the solution to all your tribological needs"
  LANGUAGES C CXX
)

# * Load project configuration.
include(${CMAKE_CURRENT_SOURCE_DIR}/tools/cmake/config.cmake)
