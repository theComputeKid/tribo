set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)

# * Identify ClangCL: https://stackoverflow.com/a/10055571
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
  set(TRIBO_CLANG_CL TRUE)
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES "MSVC" OR TRIBO_CLANG_CL)
  set(TRIBO_NO_WARN_FLAG /w)
  set(TRIBO_ASAN_COMPILE_FLAG /fsanitize=address)
  set(TRIBO_STANDARD_WARNINGS /W4 /WX /EHsc)
else()
  set(TRIBO_NO_WARN_FLAG -w)
  set(TRIBO_STANDARD_WARNINGS -Werror -Wall -Wextra -Wpedantic -Wdocumentation)
  set(TRIBO_ASAN_COMPILE_FLAG -fsanitize=address -fno-omit-frame-pointer)
  set(TRIBO_ASAN_LINK_FLAG -fsanitize=address)
endif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC" OR TRIBO_CLANG_CL)

# * Set the warnings.
if(TRIBO_DISABLE_WARNINGS)
  set(TRIBO_WARNING_FLAGS ${TRIBO_NO_WARN_FLAG})
else()
  set(TRIBO_WARNING_FLAGS ${TRIBO_STANDARD_WARNINGS})
endif(TRIBO_DISABLE_WARNINGS)

# * Use libc++ on linux with clang (already the default on MacOS so do not need to add it)
if(UNIX AND NOT APPLE AND CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  set(CMAKE_CXX_FLAGS "-stdlib=libc++ ${CMAKE_CXX_FLAGS}")
  set(CMAKE_EXE_LINKER_FLAGS "-stdlib=libc++ -lc++ -lc++abi -lm ${CMAKE_EXE_LINKER_FLAGS}")
  set(CMAKE_SHARED_LINKER_FLAGS "-stdlib=libc++ -lc++ -lc++abi -lm ${CMAKE_SHARED_LINKER_FLAGS}")
endif()
