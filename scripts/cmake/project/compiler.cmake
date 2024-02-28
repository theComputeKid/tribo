# * Identify ClangCL.
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  if(CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
    set(TRIBO_CLANG_CL TRUE)
  else()
    set(TRIBO_WINDOWS_CLANG TRUE)
  endif()
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES "MSVC" OR TRIBO_CLANG_CL)
  # * Warnings
  set(TRIBO_NO_WARN_FLAG /w)
  set(TRIBO_STANDARD_WARNINGS /W4 /WX)

  if(TRIBO_CLANG_CL)
    # * TODO: Enable sanitizers for clang-cl.
    set(TRIBO_CODE_COVERAGE_COMPILER_FLAG --coverage)
    set(TRIBO_CODE_COVERAGE_LINKER_FLAG clang_rt.profile-x86_64.lib)
  else()
    # * MSVC
    # * TODO: Enable code coverage for msvc.
    set(TRIBO_ASAN_COMPILER_FLAG /fsanitize=address)
    set(TRIBO_ASAN_LINKER_FLAG /fsanitize=address)

    # set(TRIBO_CODE_COVERAGE_COMPILER_FLAG --coverage)
    set(TRIBO_CODE_COVERAGE_LINKER_FLAG /PROFILE)
  endif()
else()
  # * Clang or GNU on either windows or unix.
  # * Warnings.
  set(TRIBO_NO_WARN_FLAG -w)
  set(TRIBO_STANDARD_WARNINGS -Werror -Wall -Wextra -Wpedantic)

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
  string(REPLACE "-O2" "-O3" CMAKE_C_FLAGS_RELEASE ${CMAKE_C_FLAGS_RELEASE})

  # * If we want to link with libc++.
  set(TRIBO_LIBCXX_COMPILER_FLAG -stdlib=libc++)
  set(TRIBO_LIBCXX_LINKER_FLAG -stdlib=libc++ -lc++ -lc++abi -lm)
endif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC" OR TRIBO_CLANG_CL)

if(APPLE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  # * Cmake does not let GCC on MacOS generate PCH files properly.
  set(TRIBO_USE_PCH OFF CACHE BOOL "" FORCE)

  # * Asan not on mac aarch64 yet.
  set(TRIBO_ENABLE_SANITIZERS OFF)
endif()

# * Copy release settings into dist.
set(CMAKE_CXX_FLAGS_DIST ${CMAKE_CXX_FLAGS_RELEASE})
set(CMAKE_C_FLAGS_DIST ${CMAKE_C_FLAGS_RELEASE})
set(CMAKE_SHARED_LINKER_FLAGS_DIST ${CMAKE_SHARED_LINKER_FLAGS_RELEASE})
set(TRIBO_CLANG_TIDY $<IF:$<CONFIG:DIST>,,${TRIBO_CLANG_TIDY}>)

# * Set the warnings.
if(TRIBO_ENABLE_WARNINGS)
  set(TRIBO_CXX_FLAGS $<IF:$<CONFIG:DIST>,${TRIBO_NO_WARN_FLAG},${TRIBO_STANDARD_WARNINGS}>)
  set(TRIBO_C_FLAGS $<IF:$<CONFIG:DIST>,${TRIBO_NO_WARN_FLAG},${TRIBO_STANDARD_WARNINGS}>)
else()
  set(TRIBO_CXX_FLAGS ${TRIBO_NO_WARN_FLAG})
  set(TRIBO_C_FLAGS ${TRIBO_NO_WARN_FLAG})
endif(TRIBO_ENABLE_WARNINGS)

if(TRIBO_ENABLE_CODECOVERAGE)
  set(TRIBO_CXX_FLAGS ${TRIBO_CXX_FLAGS} $<$<CONFIG:DEBUG>:${TRIBO_CODE_COVERAGE_COMPILER_FLAG}>)
  set(TRIBO_C_FLAGS ${TRIBO_C_FLAGS} $<$<CONFIG:DEBUG>:${TRIBO_CODE_COVERAGE_COMPILER_FLAG}>)
  set(TRIBO_LINKER_FLAGS ${TRIBO_LINKER_FLAGS} $<$<CONFIG:DEBUG>:${TRIBO_CODE_COVERAGE_LINKER_FLAG}>)
endif()

if(TRIBO_ENABLE_SANITIZERS)
  set(TRIBO_CXX_FLAGS ${TRIBO_CXX_FLAGS} $<$<CONFIG:DEBUG>:${TRIBO_ASAN_COMPILER_FLAG}>)
  set(TRIBO_C_FLAGS ${TRIBO_C_FLAGS} $<$<CONFIG:DEBUG>:${TRIBO_ASAN_COMPILER_FLAG}>)
  set(TRIBO_LINKER_FLAGS ${TRIBO_LINKER_FLAGS} $<$<CONFIG:DEBUG>:${TRIBO_ASAN_LINKER_FLAG}>)
endif()

# * Some compilers use libcxx by default anyways.
if(TRIBO_USE_LIBCXX AND NOT APPLE AND NOT TRIBO_WINDOWS_CLANG)
  set(TRIBO_USE_LIBCXX ON CACHE BOOL "" FORCE)
else()
  set(TRIBO_USE_LIBCXX OFF CACHE BOOL "" FORCE)
endif()

if(TRIBO_USE_LIBCXX)
  set(TRIBO_CXX_FLAGS ${TRIBO_CXX_FLAGS} ${TRIBO_LIBCXX_COMPILER_FLAG})
  set(TRIBO_LINKER_FLAGS ${TRIBO_LINKER_FLAGS} ${TRIBO_LIBCXX_LINKER_FLAG})
endif()

if(APPLE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  # * GCC on MacOS (arm64) does not support -fno-fat-lto-objects yet.
  # https://gitlab.kitware.com/cmake/cmake/-/issues/21696
  # https://stackoverflow.com/questions/70806677/why-does-cmake-set-no-fat-lto-objects-when-i-enable-lto-ipo
  set(CMAKE_C_COMPILE_OPTIONS_IPO "-flto=auto")

  # Linker errors with xcode 15.
  # https://forums.developer.apple.com/forums/thread/737707
  set(TRIBO_LINKER_FLAGS ${TRIBO_LINKER_FLAGS} -Wl,-ld_classic)
endif()
