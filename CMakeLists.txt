# * Main project file.
cmake_minimum_required(VERSION 3.28)

project(
  tribo
  VERSION 0.0.1
  DESCRIPTION "a point contact lubrication solver"
  LANGUAGES C CXX
)

set(
  CMAKE_CONFIGURATION_TYPES "Debug;Release"
  CACHE STRING "Allowed project configurations" FORCE
)
