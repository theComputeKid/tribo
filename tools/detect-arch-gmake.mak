# Detect OS: https://stackoverflow.com/a/12099167/9492811

# In the case ARCH was set by the user, set CLANG_ARCH accordingly.
ifdef ARCH
ifeq ($(ARCH),x64)
CLANG_ARCH := x86_64
else ifeq ($(ARCH),arm64)
CLANG_ARCH := aarch64
else
$(error Unsupported Arch: $(ARCH), expected x64 or arm64.)
endif
endif

ifeq ($(OS),Windows_NT)
$(error Use nmake on Windows instead of gnu make.)
endif

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
OS := linux
NPROC := $(shell nproc)
else ifeq ($(UNAME_S),Darwin)
OS := macos
ARCH := arm64
CLANG_ARCH := aarch64
NPROC := $(shell sysctl -n hw.ncpu)
else
$(error Unsupported OS: $(UNAME_S), expected Linux or Darwin.)
endif

ifeq ($(OS),linux)
ifndef ARCH
UNAME_P := $(shell uname -p)
ifeq ($(UNAME_P),x86_64)
ARCH := x64
CLANG_ARCH := x86_64
else ifeq ($(UNAME_P),aarch64)
ARCH := arm64
CLANG_ARCH := aarch64
else
$(error Unsupported architecture: $(UNAME_P), expected x86_64 or aarch64.)
endif
endif
endif
