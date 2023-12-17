include(CTest)

# * Threshold for passing code-coverage (% lines covered).
set(TRIBO_CODE_COVERAGE_THRESHOLD 90)

# * Code coverage tool for clang is llvm-cov in gcov emulation mode.
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  set(TRIBO_GCOV_EXE "llvm-cov gcov")
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  set(TRIBO_GCOV_EXE "gcov")
endif()

if(TRIBO_CODE_COVERAGE_COMPILER_FLAG)
  add_test(
    NAME code-coverage
    COMMAND gcovr --gcov-executable ${TRIBO_GCOV_EXE} --exclude build --html-details ${CMAKE_CURRENT_BINARY_DIR}/tribo.html --html-theme blue --fail-under-line ${TRIBO_CODE_COVERAGE_THRESHOLD}
    CONFIGURATIONS CodeCheck
    WORKING_DIRECTORY ${TRIBO_ROOT_DIR}
  )

  # * Requires all the correctness tests to be run.
  set_tests_properties(
    code-coverage
    PROPERTIES FIXTURES_REQUIRED ${TRIBO_CORRECTNESS_TESTS_FIXTURE}
  )
endif()
