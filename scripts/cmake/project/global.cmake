# * This helps with test run order dependencies.
set(TRIBO_CORRECTNESS_TESTS_FIXTURE tribo-correctness-tests)
set(TRIBO_EXPORT_HEADER_DIR ${PROJECT_SOURCE_DIR}/include)

# * CPack
set(CPACK_PACKAGE_VENDOR "theComputeKid")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_MONOLITHIC_INSTALL ON)
