# * Enable clang-tidy for builds with Clang.
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  if(NOT TRIBO_CLANG_CL)
    set(CMAKE_CXX_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet>)
    set(CMAKE_C_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet>)
  else()
    # * ClangCL bug with clang-tidy that does not pick up /EHsc: https://stackoverflow.com/a/76199998
    set(CMAKE_CXX_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet;--extra-arg=/EHsc>)
    set(CMAKE_C_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet>)
  endif()
endif()
