# * Convenience for copying compile_commands.json to the project root for
# * IDEs to find it easily.
if(TRIBO_EXPORT_COMPILE_COMMANDS)
  add_custom_target(
  copy-compile-commands ALL
  ${CMAKE_COMMAND} -E copy_if_different
  ${CMAKE_BINARY_DIR}/compile_commands.json
  ${PROJECT_SOURCE_DIR}
  )
endif(TRIBO_EXPORT_COMPILE_COMMANDS)
