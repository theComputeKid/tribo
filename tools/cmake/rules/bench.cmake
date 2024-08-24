# * Clone a version of the project that is one commit behind the latest commit.
# * We perform a performance comparison with this version.

if(TRIBO_PERF_COMPARE)
  if(NOT DEFINED TRIBO_PREVIOUS_GIT_COMMIT_HASH)
    message(FATAL_ERROR "TRIBO_PREVIOUS_GIT_COMMIT_HASH should have been defined.")
  endif()

  include(ExternalProject)

  set(
    TRIBO_PERF_CMAKE_ARGS
    -DTRIBO_ENABLE_BENCH=1
    -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
    -DTRIBO_USE_LIBCXX=${TRIBO_USE_LIBCXX}
    -DTRIBO_EXPORT_COMPILE_COMMANDS=${TRIBO_EXPORT_COMPILE_COMMANDS}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/${PROJECT_NAME}-perf-install
  )

  ExternalProject_Add(
    ${PROJECT_NAME}-perf

    # * We can clone locally from our already-existing repo.
    GIT_REPOSITORY file://${PROJECT_SOURCE_DIR}/.git
    GIT_TAG ${TRIBO_PREVIOUS_GIT_COMMIT_HASH}
    GIT_PROGRESS TRUE

    CONFIGURE_HANDLED_BY_BUILD ON

    SOURCE_DIR ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-perf
    BINARY_DIR ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-perf-build
    INSTALL_DIR ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-perf-install

    CMAKE_ARGS ${TRIBO_PERF_CMAKE_ARGS}

    EXCLUDE_FROM_ALL
  )

  set(
    TRIBO_BASELINE_PERF_EXE
    ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-perf-install/bin/${PROJECT_NAME}-bench${CMAKE_EXECUTABLE_SUFFIX}
  )
endif()
