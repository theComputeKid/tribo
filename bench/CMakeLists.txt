set(myTargetName "tribo-bench")

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

target_link_libraries(
  ${myTargetName}
  benchmark::benchmark_main
  benchmark::benchmark
  ${CMAKE_PROJECT_NAME}
)

add_dependencies(${myTargetName} ${CMAKE_PROJECT_NAME}-perf)

add_pch(${myTargetName})

install(
  TARGETS ${myTargetName}
  RUNTIME DESTINATION bin
)

add_test(
  NAME ${TRIBO_PERFORMANCE_TESTS}
  COMMAND ${TRIBO_PYTHON_EXE} ${googlebenchmark_SOURCE_DIR}/tools/compare.py benchmarks $<TARGET_FILE:tribo-bench> $<TARGET_FILE:tribo-bench>
  CONFIGURATIONS Release
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

# * Requires all the correctness tests to be run.
set_tests_properties(
  ${TRIBO_PERFORMANCE_TESTS}
  PROPERTIES FIXTURES_REQUIRED ${TRIBO_CORRECTNESS_TESTS_FIXTURE}
)
