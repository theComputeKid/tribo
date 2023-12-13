if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND NOT TRIBO_CLANG_CL)
  set(CMAKE_CXX_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet>)
  set(CMAKE_C_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet>)
endif()

# * Clang-Tidy bug: https://stackoverflow.com/a/76199998
if(TRIBO_CLANG_CL)
  set(CMAKE_CXX_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet;--extra-args=/EHsc>)
  set(CMAKE_C_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet>)
endif(TRIBO_CLANG_CL)
