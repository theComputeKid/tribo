# * Sets Google Test usage.
if(TRIBO_ENABLE_TESTS)
  enable_testing()

  set(BUILD_GMOCK OFF CACHE BOOL "" FORCE)
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

  FetchContent_Declare(
    googletest
    SYSTEM
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG main
    GIT_PROGRESS TRUE
    GIT_SHALLOW TRUE
    EXCLUDE_FROM_ALL
  )
  FetchContent_MakeAvailable(googletest)

  # * Windows requires ASAN to be linked with all objects.
  if(TRIBO_ENABLE_SANITIZERS)
    target_compile_options(
      gtest
      PRIVATE
      $<$<CONFIG:DEBUG>:${TRIBO_ASAN_COMPILER_FLAG}>
    )
    target_compile_options(
      gtest_main
      PRIVATE
      $<$<CONFIG:DEBUG>:${TRIBO_ASAN_COMPILER_FLAG}>
    )
  endif()

  if(TRIBO_USE_LIBCXX)
    target_compile_options(
      gtest
      PRIVATE
      ${TRIBO_LIBCXX_COMPILER_FLAG}
    )
    target_compile_options(
      gtest_main
      PRIVATE
      ${TRIBO_LIBCXX_COMPILER_FLAG}
    )
  endif()

  include(GoogleTest)
endif(TRIBO_ENABLE_TESTS)
