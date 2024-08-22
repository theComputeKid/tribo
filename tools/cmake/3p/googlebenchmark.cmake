# * Sets Google benchmark usage.
if(TRIBO_ENABLE_BENCH)
  enable_testing()

  if(TRIBO_USE_LIBCXX)
    set(BENCHMARK_USE_LIBCXX ON)
  endif()

  set(BENCHMARK_ENABLE_TESTING OFF)
  set(DBENCHMARK_DOWNLOAD_DEPENDENCIES ON)
  FetchContent_Declare(
    googlebenchmark
    SYSTEM
    GIT_REPOSITORY https://github.com/google/benchmark.git
    GIT_TAG v1.8.3
    GIT_PROGRESS TRUE
    GIT_SHALLOW TRUE
    EXCLUDE_FROM_ALL
  )
  FetchContent_MakeAvailable(googlebenchmark)

  if(TRIBO_ENABLE_SANITIZERS)
    target_compile_options(
      benchmark
      PRIVATE
      $<$<CONFIG:DEBUG>:${TRIBO_ASAN_COMPILER_FLAG}>
    )
    target_compile_options(
      benchmark_main
      PRIVATE
      $<$<CONFIG:DEBUG>:${TRIBO_ASAN_COMPILER_FLAG}>
    )
  endif()

  if(WIN32 AND CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    # TODO: googlebenchmark-src/src/benchmark.cc:217:7: error: offset of on
    # non-standard-layout type 'State' [-Werror,-Winvalid-offsetof]
    target_compile_options(
      benchmark
      PRIVATE
      -Wno-invalid-offsetof
    )

    # TODO: VC\Tools\MSVC\14.41.34120\include\xmemory:28:1: note: 'std'
    # namespace opened here error: modification of 'std' namespace can result in
    # undefined behavior [cert-dcl58-cpp,-warnings-as-errors]
    if(DEFINED TRIBO_CLANG_TIDY)
      set(TRIBO_CLANG_TIDY "${TRIBO_CLANG_TIDY};--checks=-cert-dcl58-cpp")
    endif()
  endif()
endif()
