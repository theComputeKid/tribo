# * Obtain number of main git commits quietly as TRIBO_GIT_COMMIT_NUMBER

if(NOT DEFINED TRIBO_GIT_BRANCH_NAME)
  message(FATAL_ERROR "TRIBO_GIT_BRANCH_NAME not defined.")
endif()

execute_process(
  COMMAND git rev-list --count ${TRIBO_GIT_BRANCH_NAME}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  ERROR_QUIET
  OUTPUT_VARIABLE TRIBO_GIT_COMMIT_NUMBER
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

# * Just in case we are not in a git repo (or git doesn't exist).
if(TRIBO_GIT_COMMIT_NUMBER STREQUAL "")
  set(TRIBO_GIT_COMMIT_NUMBER 0)
endif(TRIBO_GIT_COMMIT_NUMBER STREQUAL "")

# * Just in case we have less than 2 commits.
if(TRIBO_GIT_COMMIT_NUMBER LESS 2)
  if(TRIBO_PERF_COMPARE)
    message(WARNING "TRIBO_PERF_COMPARE requested but we have less than 2 commits. Turning TRIBO_PERF_COMPARE OFF.")
    set(TRIBO_PERF_COMPARE OFF)
  endif()
endif()
