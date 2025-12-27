MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifeq ($(OS)-$(CC),windows-cc)
COMPILER_FAMILY = clang
override CC = clang
else ifeq ($(OS)-$(CC),linux-cc)
COMPILER_FAMILY = gcc
else ifeq ($(OS)-$(CC),macos-cc)
COMPILER_FAMILY = clang
else ifneq ($(findstring clang,$(CC)),)
COMPILER_FAMILY = clang
else ifneq ($(findstring icx,$(CC)),)
COMPILER_FAMILY = icx
else ifneq ($(findstring gcc,$(CC)),)
COMPILER_FAMILY = gcc
else
$(error Unsupported CC '$(CC)'. Expected clang, gcc or icx.)
endif

# Include compiler-specific settings.
include $(MAKEFILE_DIR)/$(COMPILER_FAMILY).mak

# Common compiler flags.
CFLAGS += -Wall -Wextra -Wpedantic -std=c17 -MMD
CFLAGS_DEBUG += -g -O0 -fno-omit-frame-pointer -fsanitize=address,undefined
CFLAGS_RELEASE += -O3
ARFLAGS = rcs
LDFLAGS_DEBUG += -fsanitize=address,undefined

ifneq ($(WERROR),0)
CFLAGS += -Werror
LDFLAGS += -Werror
endif

ifneq ($(OPENMP),0)
CFLAGS += $(OMP_FLAG)
LDFLAGS += $(OMP_FLAG)
endif

ifeq ($(DEBUG),1)
CFLAGS += $(strip $(CFLAGS_DEBUG))
LDFLAGS += $(strip $(LDFLAGS_DEBUG))
else
CFLAGS += $(strip $(CFLAGS_RELEASE))
LDFLAGS += $(strip $(LDFLAGS_RELEASE))
endif

AVX_FLAG = -mavx
AVX512_FLAG = -mavx512f

ifeq ($(OS),windows)
AR = llvm-ar
else
AR = ar
endif
