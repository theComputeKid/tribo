# * Builds ninja.
ExternalProject_Add(
  ninja
  GIT_REPOSITORY https://github.com/ninja-build/ninja.git
  GIT_TAG master
  GIT_PROGRESS TRUE
  GIT_SHALLOW TRUE
  SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/ninja
  BUILD_COMMAND ${CMAKE_COMMAND} --build . -j${TRIBO_NUM_CPU_CORES} --config Release
  CMAKE_ARGS
  -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  -DBUILD_TESTING=OFF
)

# * Adds ninja path in case we need to build other tools using this ninja.
set(TRIBO_NINJA_PATH ${CMAKE_INSTALL_PREFIX}/bin/ninja)
