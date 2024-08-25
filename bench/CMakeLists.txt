set(myTargetName ${PROJECT_NAME}-bench)

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
  ${PROJECT_NAME}
)

add_pch(${myTargetName})

install(
  TARGETS ${myTargetName}
  RUNTIME DESTINATION bin
)

# * If we want to compare results, we need python.
if(TRIBO_PERF_COMPARE)
  add_dependencies(${myTargetName} ${PROJECT_NAME}-perf)
  add_test(
    NAME ${TRIBO_PERFORMANCE_TESTS}
    COMMAND ${TRIBO_PYTHON_EXE} ${googlebenchmark_SOURCE_DIR}/tools/compare.py --dump_to_json bench.json benchmarks "${TRIBO_BASELINE_PERF_EXE}" $<TARGET_FILE:${PROJECT_NAME}-bench>
    CONFIGURATIONS Release
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )
  add_test(
    NAME ${TRIBO_PERFORMANCE_TESTS}-check
    COMMAND ${TRIBO_PYTHON_EXE} ${PROJECT_SOURCE_DIR}/tools/check-perf.py "${CMAKE_BINARY_DIR}/bench.json"
    CONFIGURATIONS Release
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )
  set_tests_properties(${TRIBO_PERFORMANCE_TESTS}-check PROPERTIES DEPENDS ${TRIBO_PERFORMANCE_TESTS})
else()
  add_test(
    NAME ${TRIBO_PERFORMANCE_TESTS}
    COMMAND $<TARGET_FILE:tribo-bench> --benchmark_out=bench.json
    CONFIGURATIONS Release
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )
endif()

# * Requires all the correctness tests to be run.
set_tests_properties(
  ${TRIBO_PERFORMANCE_TESTS}
  PROPERTIES FIXTURES_REQUIRED ${TRIBO_CORRECTNESS_TESTS_FIXTURE}
)
