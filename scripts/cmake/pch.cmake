# * Include to add PCH for a target. Must define ${myTargetName}.
if(TRIBO_USE_PCH)
  target_precompile_headers(
    ${myTargetName}
    PRIVATE
    $<$<COMPILE_LANGUAGE:C>:${CMAKE_CURRENT_SOURCE_DIR}/pch.h>
    $<$<COMPILE_LANGUAGE:CXX>:${CMAKE_CURRENT_SOURCE_DIR}/pch.hpp>
  )

  # * CMake's clang-tidy integration cannot handle PCH. So we filter it out.
  # * There is no elegant way of finding the CXX file that CMake auto-generates for the PCH.
  file(GLOB_RECURSE PCH_FILES CONFIGURE_DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${myTargetName}.dir/*.c*)
  set_source_files_properties(${PCH_FILES} PROPERTIES SKIP_LINTING ON)
endif(TRIBO_USE_PCH)
