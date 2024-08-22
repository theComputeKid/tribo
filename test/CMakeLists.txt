set(myTargetName "tribo-test")

add_executable(
  ${myTargetName}
  info.cpp
)

set_target_properties(
  ${myTargetName}
  PROPERTIES
  COMPILE_OPTIONS "${TRIBO_CXX_FLAGS}"
  COMPILE_WARNING_AS_ERROR ${TRIBO_ENABLE_WARNINGS}
  CXX_CLANG_TIDY "${TRIBO_CLANG_TIDY}"
  CXX_EXTENSIONS OFF
  CXX_SCAN_FOR_MODULES OFF
  CXX_STANDARD 23
  CXX_STANDARD_REQUIRED ON
  CXX_VISIBILITY_PRESET hidden
  EXPORT_COMPILE_COMMANDS ${TRIBO_EXPORT_COMPILE_COMMANDS}
  INCLUDE_DIRECTORIES "${TRIBO_EXPORT_HEADER_DIR}"
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
  LINK_OPTIONS "${TRIBO_LINKER_FLAGS}"
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
  VISIBILITY_INLINES_HIDDEN ON
)

set_source_files_properties(
  info.cpp
  PROPERTIES

  # Skip pch because macro specially defined for this file.
  COMPILE_DEFINITIONS "${TRIBO_PROJECT_VERSION_DEFINES}"
  SKIP_PRECOMPILE_HEADERS ON
)

target_link_libraries(${myTargetName}
  PRIVATE GTest::gtest GTest::gtest_main ${CMAKE_PROJECT_NAME}
)

# * These tests are part of the correctness test-suite.
gtest_discover_tests(
  ${myTargetName}
  PROPERTIES FIXTURES_SETUP ${TRIBO_CORRECTNESS_TESTS_FIXTURE}
)

add_pch(${myTargetName})

install(
  TARGETS ${myTargetName}
  RUNTIME DESTINATION bin
)
