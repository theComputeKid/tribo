# * Enable the use of argParse as a dependency.

set(ARGPARSE_BUILD_TESTS OFF CACHE BOOL "" FORCE)

FetchContent_Declare(
  argparse
  SYSTEM
  GIT_REPOSITORY https://github.com/p-ranav/argparse.git
  GIT_TAG v3.0
  GIT_PROGRESS TRUE
  GIT_SHALLOW TRUE
  EXCLUDE_FROM_ALL
)
FetchContent_MakeAvailable(argparse)
