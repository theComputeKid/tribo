# * Get current folder basename to use as the output target name.
cmake_path(GET CMAKE_CURRENT_SOURCE_DIR STEM LAST_ONLY myDirBaseName)
set(myTargetName "${TRIBO_PRJ_NAME}${TRIBO_NAME_SEPERATOR}${myDirBaseName}")

add_executable(
  ${myTargetName}
  main.cpp
  info.cpp
)

set_target_properties(
  ${myTargetName}
  PROPERTIES
  CXX_STANDARD 23
  CXX_EXTENSIONS OFF
  CXX_STANDARD_REQUIRED ON
  CXX_SCAN_FOR_MODULES OFF
)

# * Enable build information macros for one file only. PCH can't be used due to macro definition.
set_source_files_properties(
  info.cpp main.cpp
  PROPERTIES
  SKIP_PRECOMPILE_HEADERS YES
  COMPILE_DEFINITIONS TRIBO_PROJECT_VERSION_MAJOR=${TRIBO_PROJECT_VERSION_MAJOR}$<SEMICOLON>TRIBO_PROJECT_VERSION_MINOR=${TRIBO_PROJECT_VERSION_MINOR}$<SEMICOLON>TRIBO_PROJECT_VERSION_PATCH=${TRIBO_PROJECT_VERSION_PATCH}$<SEMICOLON>TRIBO_GIT_COMMIT_HASH=\"${TRIBO_GIT_COMMIT_HASH}\"
)

include(${TRIBO_CMAKE_SCRIPTS_DIR}/pch.cmake)

target_include_directories(${myTargetName} PUBLIC ${TRIBO_EXPORT_HEADER_DIR})

target_link_libraries(${myTargetName}
  PRIVATE GTest::gtest argparse tribo
)

# * These tests are part of the correctness test-suite.
gtest_discover_tests(
  ${myTargetName}
  PROPERTIES FIXTURES_SETUP ${TRIBO_CORRECTNESS_TESTS_FIXTURE}
)
