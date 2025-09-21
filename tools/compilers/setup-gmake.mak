MAKEFILE_DIR = $(dir $(lastword $(MAKEFILE_LIST)))

ifeq ($(OS),linux)
ifeq ($(CC), cc)
include $(MAKEFILE_DIR)/gcc.mak
else ifneq ($(findstring clang,$(CC)),)
include $(MAKEFILE_DIR)/clang.mak
else ifneq ($(findstring gcc,$(CC)),)
include $(MAKEFILE_DIR)/gcc.mak
else ifneq ($(findstring icx,$(CC)),)
include $(MAKEFILE_DIR)/icx.mak
endif
endif

ifeq ($(OS),macos)
ifeq ($(CC), cc)
include $(MAKEFILE_DIR)/clang-apple.mak
else ifneq ($(findstring gcc-,$(CC)),) # Actual GCC on MacOS has a version.
include $(MAKEFILE_DIR)/gcc-brew.mak
else ifeq ($(CC), clang)
include $(MAKEFILE_DIR)/clang-brew.mak
else ifeq ($(CC), gcc) # GCC on MacOS is an alias to clang.
include $(MAKEFILE_DIR)/clang-brew.mak
endif
endif

# Set flags based on build type.
ifeq ($(DEBUG),1)
CFLAGS = $(strip $(CFLAGS_DEBUG))
CXXFLAGS = $(strip $(CXXFLAGS_DEBUG))
LDFLAGS = $(strip $(LDFLAGS_DEBUG))
else
CFLAGS = $(strip $(CFLAGS_RELEASE))
CXXFLAGS = $(strip $(CXXFLAGS_RELEASE))
LDFLAGS = $(strip $(LDFLAGS_RELEASE))
endif

# ISA Flags: x64
ISA_FLAGS_AVX = -mavx
ISA_FLAGS_AVX2 = -mavx2
ISA_FLAGS_AVX512 = -mavx512f

# Used for clang tidy and compile_commands.json generation.
CTIDYFLAGS = -Wall -Wextra -Werror -std=c2x

ifeq ($(OS),macos)
LLVM_DIR ?= $(shell brew --prefix llvm)
CLANGTIDY ?= $(LLVM_DIR)/bin/clang-tidy
RUNCLANGTIDY ?= $(LLVM_DIR)/bin/run-clang-tidy
else ifeq ($(OS),linux)
CLANGTIDY ?= clang-tidy
RUNCLANGTIDY ?= run-clang-tidy
endif
