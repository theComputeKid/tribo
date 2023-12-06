# * For the poor souls who do not have the latest tools on their system.
set(CMAKE_CONFIGURATION_TYPES "Release" CACHE STRING "" FORCE)

cmake_minimum_required(VERSION 3.2)

project(
  extra-build-tools
  VERSION 1.0
)

include(ExternalProject)

cmake_host_system_information(
  RESULT TRIBO_NUM_CPU_CORES
  QUERY NUMBER_OF_PHYSICAL_CORES
)

# * Build ninja first and then use it to build other things.
include(${TRIBO_CMAKE_SCRIPTS_DIR}/tools/ninja.cmake)
include(${TRIBO_CMAKE_SCRIPTS_DIR}/tools/cmake.cmake)
