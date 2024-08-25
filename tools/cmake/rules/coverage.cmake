if(TRIBO_ENABLE_CODECOVERAGE)
  include(CTest)

  set(TRIBO_SRC_DIR backend)
  if(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    # * Use opencppcoverage
    add_test(
      NAME code-coverage
      COMMAND opencppcoverage --sources=tribo\\${TRIBO_SRC_DIR} --modules tribo.dll --excluded_sources build --export_type html --export_type cobertura:coverage.xml -- $<TARGET_FILE:tribo-test>
      CONFIGURATIONS Debug
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
  else()
    # * Use gcov

    # * Threshold for passing code-coverage (% lines covered).
    set(TRIBO_CODE_COVERAGE_THRESHOLD 100)

    # * Deduce whether to use gcov, or llvm-cov based on compiler.
    if(NOT TRIBO_GCOV_EXE)
      if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        set(TRIBO_GCOV_EXE "llvm-cov gcov")
      else()
        set(TRIBO_GCOV_EXE "gcov")
      endif()
    endif()

    add_test(
      NAME code-coverage
      COMMAND gcovr --gcov-executable ${TRIBO_GCOV_EXE} --filter ${TRIBO_SRC_DIR} --html-details ${CMAKE_CURRENT_BINARY_DIR}/coverage.html --cobertura ${CMAKE_CURRENT_BINARY_DIR}/coverage.xml --html-theme blue --fail-under-line ${TRIBO_CODE_COVERAGE_THRESHOLD} ${CMAKE_CURRENT_BINARY_DIR}
      CONFIGURATIONS Debug
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    )

    # TODO: Find a way to delete *.gcda on windows. Needs an appropriate command.
    # * Deletion is necessary so that if the source files change, the gcda doesn't go out of sync with the gcno.
    if(NOT WIN32)
      add_test(
        NAME delete-code-coverage
        COMMAND find ${CMAKE_CURRENT_BINARY_DIR}/${TRIBO_SRC_DIR} -name "*.gcda" -type f -delete
        CONFIGURATIONS Debug
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      )
      set_tests_properties(delete-code-coverage PROPERTIES DEPENDS "code-coverage")
    endif()
  endif()

  # * Requires all the correctness tests to be run.
  set_tests_properties(
    code-coverage
    PROPERTIES FIXTURES_REQUIRED ${TRIBO_CORRECTNESS_TESTS_FIXTURE}
  )
endif()
