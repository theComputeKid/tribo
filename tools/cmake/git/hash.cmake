# * Obtain git hash quietly as TRIBO_GIT_COMMIT_HASH
execute_process(
  COMMAND git log -1 --format=%H
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  ERROR_QUIET
  OUTPUT_VARIABLE TRIBO_GIT_COMMIT_HASH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

# * Just in case we are not in a git repo (or git doesn't exist).
if(TRIBO_GIT_COMMIT_HASH STREQUAL "")
  set(TRIBO_GIT_COMMIT_HASH "0x00")
endif(TRIBO_GIT_COMMIT_HASH STREQUAL "")

# * Obtain git hash quietly as TRIBO_GIT_COMMIT_HASH
execute_process(
  COMMAND git show HEAD^1 --format=%H -s
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  ERROR_QUIET
  OUTPUT_VARIABLE TRIBO_PREVIOUS_GIT_COMMIT_HASH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

# * Just in case we are not in a git repo (or git doesn't exist).
if(TRIBO_PREVIOUS_GIT_COMMIT_HASH STREQUAL "")
  set(TRIBO_PREVIOUS_GIT_COMMIT_HASH "0x00")

  if(TRIBO_PERF_COMPARE)
    message(WARNING "TRIBO_PERF_COMPARE requested but previous git commit not found. Turning TRIBO_PERF_COMPARE OFF.")
    set(TRIBO_PERF_COMPARE OFF)
  endif()
endif()
