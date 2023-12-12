if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  set(CMAKE_CXX_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet>)
  set(CMAKE_C_CLANG_TIDY $<$<CONFIG:CodeCheck>:clang-tidy;--quiet>)
endif()
