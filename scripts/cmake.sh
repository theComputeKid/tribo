#!/usr/bin/env bash
# * Wrapper to make it easy to use the internal cmake.

if [ "$(uname)" == "Darwin" ]; then
  OS=Darwin
else
  OS=Linux
fi

./build/$OS/tools/install/bin/cmake "$@"
