#!/usr/bin/env bash
# * Builds everything for Linux and MacOS. To be called from the project root. To perform a clean build specify: clean-build

# * Exit on first failure.
set -e

if [ "$(uname)" == "Darwin" ]; then
  OS=Darwin
else
  OS=Linux
fi

if [ "$1" == "clean-build" ]; then
rm -rf build/$OS
fi

./scripts/build-tools.sh
