if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
  set(TRIBO_NO_WARN_FLAG /w)
  set(TRIBO_STANDARD_WARNINGS /W4)

  # * TODO: Enable sanitizers for clang-cl.
  set(TRIBO_CODE_COVERAGE_COMPILER_FLAG --coverage)
  set(TRIBO_CODE_COVERAGE_LINKER_FLAG clang_rt.profile-x86_64.lib)
endif()