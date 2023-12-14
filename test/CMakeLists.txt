# * Get current folder basename to use as the output target name.
cmake_path(GET CMAKE_CURRENT_SOURCE_DIR STEM LAST_ONLY myDirBaseName)
set(myTargetName "${TRIBO_PRJ_NAME}${TRIBO_NAME_SEPERATOR}${myDirBaseName}")

add_executable(
  ${myTargetName}
  main.cpp
  info.cpp
)

set_target_properties(
  ${myTargetName}
  PROPERTIES
  CXX_STANDARD 23
  CXX_EXTENSIONS OFF
  CXX_STANDARD_REQUIRED ON
  CXX_SCAN_FOR_MODULES OFF
  COMPILE_DEFINITIONS TRIBO_PROJECT_VERSION_MAJOR=${TRIBO_PROJECT_VERSION_MAJOR}$<SEMICOLON>TRIBO_PROJECT_VERSION_MINOR=${TRIBO_PROJECT_VERSION_MINOR}$<SEMICOLON>TRIBO_PROJECT_VERSION_PATCH=${TRIBO_PROJECT_VERSION_PATCH}$<SEMICOLON>TRIBO_GIT_COMMIT_HASH=\"${TRIBO_GIT_COMMIT_HASH}\"
)

# * PCH CMake bug.
if(NOT TRIBO_CLANG_CL)
  target_precompile_headers(
    ${myTargetName}
    PRIVATE
    pch.hpp
  )

  # * CMake's clang-tidy integration cannot handle PCH. So we filter it out.
  # * There is no elegant way of finding the CXX file that CMake auto-generates for the PCH.
  file(GLOB_RECURSE PCH_FILES CONFIGURE_DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${myTargetName}.dir/*.cxx)
  set_source_files_properties(${PCH_FILES} PROPERTIES SKIP_LINTING ON)
endif(NOT TRIBO_CLANG_CL)

target_compile_options(
  ${myTargetName}
  PRIVATE
  ${TRIBO_WARNING_FLAGS}
)

target_include_directories(${myTargetName} PUBLIC ${TRIBO_EXPORT_HEADER_DIR})

target_link_libraries(${myTargetName}
  PRIVATE GTest::gtest argparse tribo
)

gtest_discover_tests(${myTargetName})
