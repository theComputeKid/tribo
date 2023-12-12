set(myTargetName ${TRIBO_PRJ_NAME})

add_library(
  ${myTargetName}
  SHARED
  info.c
)

# * Enable build information macros for one file only.
set_source_files_properties(
  info.c
  PROPERTIES
  COMPILE_DEFINITIONS TRIBO_PROJECT_VERSION_MAJOR=${TRIBO_PROJECT_VERSION_MAJOR}$<SEMICOLON>TRIBO_PROJECT_VERSION_MINOR=${TRIBO_PROJECT_VERSION_MINOR}$<SEMICOLON>TRIBO_PROJECT_VERSION_PATCH=${TRIBO_PROJECT_VERSION_PATCH}
)

set_target_properties(
  ${myTargetName}
  PROPERTIES
  CXX_STANDARD 23
  CXX_EXTENSIONS OFF
  CXX_STANDARD_REQUIRED ON
  VERSION ${TRIBO_PROJECT_VERSION}
  SOVERSION ${TRIBO_PROJECT_VERSION_MAJOR}
  DEFINE_SYMBOL ${TRIBO_EXPORT_MACRO}
  PUBLIC_HEADER ${TRIBO_EXPORT_HEADER_DIR}/tribo.h
)

target_compile_options(
  ${myTargetName}
  PRIVATE
  ${TRIBO_WARNING_FLAGS}
)

target_precompile_headers(
  ${myTargetName}
  PRIVATE
  pch.h
)

# * CMake's clang-tidy integration cannot handle PCH. So we filter it out.
# * There is no elegant way of finding the CXX file that CMake auto-generates for the PCH.
file(GLOB_RECURSE PCH_FILES CONFIGURE_DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${myTargetName}.dir/*.c*)
set_source_files_properties(${PCH_FILES} PROPERTIES SKIP_LINTING ON)

target_include_directories(${myTargetName} PUBLIC ${TRIBO_EXPORT_HEADER_DIR})

install(
  TARGETS ${myTargetName}
  RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_PREFIX}/include
)
