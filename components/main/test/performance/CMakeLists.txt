# * Get current folder basename to use as the output target name.
cmake_path(GET CMAKE_CURRENT_SOURCE_DIR STEM LAST_ONLY myDirBaseName)
set(myTargetName "${TRIBO_PRJ_NAME}${TRIBO_NAME_SEPERATOR}${myDirBaseName}")
