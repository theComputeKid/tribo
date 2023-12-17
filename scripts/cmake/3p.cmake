# * Enable 3p dependencies.

include(FetchContent)

# * Disable compile command generation otherwise it will mess with our
# * code-checking.
# if(CMAKE_EXPORT_COMPILE_COMMANDS)
# set(CMAKE_EXPORT_COMPILE_COMMANDS OFF)
# set(wasExportingCC ON)
# else()
# set(wasExportingCC OFF)
# endif(CMAKE_EXPORT_COMPILE_COMMANDS)

# * Disable clang-tidy.
set(myOriginalClangTidy ${CMAKE_CXX_CLANG_TIDY})
set(CMAKE_CXX_CLANG_TIDY "")

# * Disable warnings and code coverage. Save them first.
set(myOriginalCXXFlags ${CMAKE_CXX_FLAGS})
set(myOriginalCXXFlagsCodeCheck ${CMAKE_CXX_FLAGS_CODECHECK})

# * Clang on windows gives a warning about _try in gtest being an extension of C++.
string(REPLACE "${TRIBO_STANDARD_WARNINGS}" "${TRIBO_NO_WARN_FLAG}" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

# * We don't need code coverage for this.
string(REPLACE "${TRIBO_CODE_COVERAGE_COMPILER_FLAG}" "" CMAKE_CXX_FLAGS_CODECHECK "${CMAKE_CXX_FLAGS_CODECHECK}")

include(${TRIBO_CMAKE_SCRIPTS_DIR}/3p/argparse.cmake)

if(TRIBO_ENABLE_TESTS)
  include(${TRIBO_CMAKE_SCRIPTS_DIR}/3p/googletest.cmake)
endif(TRIBO_ENABLE_TESTS)

# if(wasExportingCC)
# set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# endif(wasExportingCC)

# * Re-enable clang-tidy.
set(CMAKE_CXX_CLANG_TIDY ${myOriginalClangTidy})

# * Re-enable code coverage and warnings.
set(CMAKE_CXX_FLAGS ${myOriginalCXXFlags})
set(CMAKE_CXX_FLAGS_CODECHECK ${myOriginalCXXFlagsCodeCheck})
