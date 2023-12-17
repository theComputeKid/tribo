# * Enable clang-tidy for builds with Clang.
if(TRIBO_CODECHECK_ENABLE_CLANGTIDY)
  # * Clang-tidy does not work with PCH on windows with cmake (yet).
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND NOT TRIBO_CLANG_CL)
    set(CMAKE_CXX_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet>)
    set(CMAKE_C_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet>)
  endif()
endif()
