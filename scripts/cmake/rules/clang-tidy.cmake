# * Enable clang-tidy for builds with Clang.
if(TRIBO_CODECHECK_ENABLE_CLANGTIDY)
  if(TRIBO_CLANG_CL OR CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    # * ClangCL bug with clang-tidy that does not pick up /EHsc: https://stackoverflow.com/a/76199998
    set(CMAKE_CXX_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet;--extra-arg=/EHsc>)
    set(CMAKE_C_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet>)
  else()
    set(CMAKE_CXX_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet>)
    set(CMAKE_C_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet>)
  endif()
endif()
