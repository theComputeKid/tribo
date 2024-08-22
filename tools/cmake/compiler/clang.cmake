if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "GNU")
  set(TRIBO_NO_WARN_FLAG -w)
  set(TRIBO_STANDARD_WARNINGS -Wall -Wextra -Wpedantic)

  if(NOT WIN32)
    # * Clang/GNU on Unix.
    # * TODO: Enable sanitizers for clang on Windows. Can't be done yet for debug mode.
    # * https://github.com/google/sanitizers/wiki/AddressSanitizerWindowsPort#debugging
    set(TRIBO_ASAN_COMPILER_FLAG -fsanitize=address -fno-omit-frame-pointer -fsanitize=undefined)
    set(TRIBO_ASAN_LINKER_FLAG -fsanitize=address -fsanitize=undefined)
  endif()

  # * Code coverage.
  set(TRIBO_CODE_COVERAGE_COMPILER_FLAG --coverage)
  set(TRIBO_CODE_COVERAGE_LINKER_FLAG --coverage)

  # * Release flags.
  string(REPLACE "-O2" "-O3" CMAKE_CXX_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE})

  # * If we want to link with libc++.
  set(TRIBO_LIBCXX_COMPILER_FLAG -stdlib=libc++)
  set(TRIBO_LIBCXX_LINKER_FLAG -stdlib=libc++ -lc++ -lc++abi -lm)
endif()
