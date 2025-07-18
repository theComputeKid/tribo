# Builds Premake. Change into this directory to run script.
set -e
if [ "$(uname)" == "Darwin" ]; then
  PLATFORM=Universal
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  ARCH=$(uname -m)
  if [ "$ARCH" == "x86_64" ]; then
    PLATFORM=x64
  elif [ "$ARCH" == "aarch64" ]; then
    PLATFORM=arm64
  else
    echo Unsupported OS for this script.
    exit 1
  fi
else
  echo Unsupported OS for this script.
  exit 1
fi

PLATFORM=$PLATFORM ./premake-core/Bootstrap.sh
cp ./premake-core/bin/release/premake5 ..
./../premake5 --version