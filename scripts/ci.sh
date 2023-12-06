#!/usr/bin/env bash
# * CI script for Linux and MacOS. Builds everything. To be called from the project root. To perform a clean build specify:
# * ./scripts/ci.sh clean-build

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
