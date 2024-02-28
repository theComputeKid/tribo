set(myTargetName "tribo-bench")

add_executable(
  ${myTargetName}
  info.cpp
  domain.cpp
)

set_target_properties(
  ${myTargetName}
  PROPERTIES
  CXX_STANDARD 23
  CXX_EXTENSIONS OFF
  CXX_STANDARD_REQUIRED ON
  CXX_SCAN_FOR_MODULES OFF
  EXPORT_COMPILE_COMMANDS ${TRIBO_EXPORT_COMPILE_COMMANDS}
  CXX_VISIBILITY_PRESET hidden
  C_VISIBILITY_PRESET hidden
  CXX_CLANG_TIDY "${TRIBO_CLANG_TIDY}"
  C_CLANG_TIDY "${TRIBO_CLANG_TIDY}"
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
  LINK_OPTIONS "${TRIBO_LINKER_FLAGS}"
  VISIBILITY_INLINES_HIDDEN ON
)

target_compile_options(
  ${myTargetName}
  PRIVATE
  $<$<COMPILE_LANGUAGE:CXX>:${TRIBO_CXX_FLAGS}>
  $<$<COMPILE_LANGUAGE:C>:${TRIBO_C_FLAGS}>
)

target_include_directories(${myTargetName} PUBLIC ${TRIBO_EXPORT_HEADER_DIR})

target_link_libraries(${myTargetName}
  benchmark::benchmark_main benchmark::benchmark tribo
)

add_pch(${myTargetName})

install(
  TARGETS ${myTargetName}
  RUNTIME DESTINATION bin
)
