# * Packaging via CPack.
if(PROJECT_IS_TOP_LEVEL)
  set(CPACK_PACKAGE_VENDOR "theComputeKid")
  set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
  set(CPACK_MONOLITHIC_INSTALL ON)
  include(CPack)
endif()