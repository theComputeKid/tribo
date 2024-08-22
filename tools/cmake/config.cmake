# * Add build configs first to make sure we are building correctly.
include(${CMAKE_CURRENT_LIST_DIR}/project/build-config.cmake)

# * Add git utils.
include(${CMAKE_CURRENT_LIST_DIR}/git/branch.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/git/commit-count.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/git/hash.cmake)

# * Add project config.
include(${CMAKE_CURRENT_LIST_DIR}/project/global.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/project/pch.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/project/cpack.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/project/test.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/project/bench-version-clone.cmake)

# * Select compiler options based on compiler.
include(${CMAKE_CURRENT_LIST_DIR}/compiler/clang.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/compiler/clang-cl.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/compiler/msvc.cmake)

# * Select the correct compiler flags based on build configuration.
include(${CMAKE_CURRENT_LIST_DIR}/compiler/selection.cmake)

# * Custom rules.
include(${CMAKE_CURRENT_LIST_DIR}/rules/compile-commands.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/rules/coverage.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/rules/doxygen.cmake)

# * External dependencies.
include(FetchContent)
include(ExternalProject)
include(${CMAKE_CURRENT_LIST_DIR}/3p/googletest.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/3p/googlebenchmark.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/3p/python.cmake)
