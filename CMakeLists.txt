# * CMake 3.28 required due to:
# * Schema field in CMakePresets.json (v8).
# * C++20 module support.
# * FetchContent EXCLUDE_FROM_ALL.
cmake_minimum_required(VERSION 3.28)

project(
  tribosolver
  VERSION 0.0.1
  DESCRIPTION "a point contact lubrication solver"
)
