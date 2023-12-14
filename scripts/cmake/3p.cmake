# * Enable 3p dependencies.

include(FetchContent)

# * Disable compile command generation otherwise it will mess with our
# * code-checking.
if(CMAKE_EXPORT_COMPILE_COMMANDS)
  set(CMAKE_EXPORT_COMPILE_COMMANDS OFF)
  set(wasExportingCC ON)
else()
  set(wasExportingCC OFF)
endif(CMAKE_EXPORT_COMPILE_COMMANDS)

# * Disable clang-tidy.
set(myOriginalClangTidy ${CMAKE_CXX_CLANG_TIDY})
set(CMAKE_CXX_CLANG_TIDY "")

include(${TRIBO_CMAKE_SCRIPTS_DIR}/3p/argparse.cmake)

if(TRIBO_ENABLE_TESTS)
  include(${TRIBO_CMAKE_SCRIPTS_DIR}/3p/googletest.cmake)
endif(TRIBO_ENABLE_TESTS)

if(wasExportingCC)
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
endif(wasExportingCC)

# * Re-enable clang-tidy.
set(CMAKE_CXX_CLANG_TIDY ${myOriginalClangTidy})
