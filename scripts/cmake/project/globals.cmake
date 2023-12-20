# * Global variables.

# * Native CMake variables.
set(
  CMAKE_CONFIGURATION_TYPES "Debug;Release;CodeCheck"
  CACHE STRING "Allowed project configurations" FORCE
)

# * So windows exe can find the DLLs, we put them in the same folder: https://stackoverflow.com/a/55886605
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR})
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})

# * Project variables.
set(TRIBO_PROJECT_VERSION ${PROJECT_VERSION})
set(TRIBO_PROJECT_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(TRIBO_PROJECT_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(TRIBO_PROJECT_VERSION_PATCH ${PROJECT_VERSION_PATCH})

set(TRIBO_PRJ_NAME ${CMAKE_PROJECT_NAME})
set(TRIBO_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(TRIBO_NAME_SEPERATOR "-") # Seperator in output names. e.g: libXYZ-ABC.so
set(TRIBO_EXPORT_HEADER_DIR ${TRIBO_ROOT_DIR}/components/include)
set(TRIBO_EXPORT_MACRO "TRIBO_EXPORT_API")

# * This helps with test run order dependencies.
set(TRIBO_CORRECTNESS_TESTS_FIXTURE tribo-correctness-tests)
