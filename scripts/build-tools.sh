#!/usr/bin/env bash
# * Helper script to build tools if they are not present on the system.

if [ "$(uname)" == "Darwin" ]; then
  OS=Darwin
else
  OS=Linux
fi

cmake \
-S . -B build/$OS/tools \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=build/$OS/tools/install -DTRIBO_BUILD_TOOLS=ON && \
cmake --build build/$OS/tools
