# * Obtain current branch quietly as TRIBO_GIT_BRANCH_NAME
execute_process(
  COMMAND git branch --show-current
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  ERROR_QUIET
  OUTPUT_VARIABLE TRIBO_GIT_BRANCH_NAME
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

# * Just in case we are not in a git repo (or git doesn't exist).
if(TRIBO_GIT_BRANCH_NAME STREQUAL "")
  set(TRIBO_GIT_BRANCH_NAME "none")
endif(TRIBO_GIT_BRANCH_NAME STREQUAL "")
