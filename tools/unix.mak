OUT_EXT :=
OBJ_EXT := .o

define delete-folder
rm -rf $(1)
endef

define delete-file
rm -f $(1)
endef

define print-file
cat $(1)
endef

ifeq ($(OS),Darwin)
ARCH := arm64
LIB_EXT := .dylib
endif

ifeq ($(OS),Linux)
LIB_EXT := .so
UNAME_P := $(shell uname -p)
ifeq ($(UNAME_P),x86_64)
ARCH ?= x64
else ifeq ($(UNAME_P),aarch64)
ARCH ?= arm64
endif
endif
