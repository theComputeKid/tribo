MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifeq ($(OS)-$(CC),windows-cc)
COMPILER_FAMILY = clang
override CC = clang
LD = lld
OMP_FLAG = -fopenmp
else ifeq ($(OS)-$(CC),linux-cc)
COMPILER_FAMILY = gcc
LD = ld
OMP_FLAG = -fopenmp
else ifeq ($(OS)-$(CC),macos-cc)
COMPILER_FAMILY = appleclang
LD = apple
else ifneq ($(findstring clang,$(CC)),)
COMPILER_FAMILY = clang
LD = lld
OMP_FLAG = -fopenmp
else ifneq ($(findstring icx,$(CC)),)
COMPILER_FAMILY = icx
LD = lld
OMP_FLAG = -qopenmp
else ifneq ($(findstring gcc,$(CC)),)
COMPILER_FAMILY = gcc
LD = ld
OMP_FLAG = -fopenmp
else
$(error Unsupported CC '$(CC)'. Expected clang, gcc or icx.)
endif

ifeq ($(OS)-$(COMPILER_FAMILY),macos-gcc)
LD = apple
endif

include $(MAKEFILE_DIR)/linker.mak

# Common compiler flags.
CFLAGS += -Wall -Wextra -Wpedantic -std=c17 -MMD
CFLAGS_DEBUG += -g -O0 -fno-omit-frame-pointer -fsanitize=address,undefined
CFLAGS_RELEASE += -O3 -save-temps=obj -Wno-gnu-line-marker
LDFLAGS_DEBUG += -fsanitize=address,undefined

ifneq ($(OS),windows)
CFLAGS += -fPIC
else
CFLAGS += -D_CRT_SECURE_NO_WARNINGS
endif

ifneq ($(WERROR),0)
CFLAGS += -Werror
LDFLAGS += $(LD_WERROR_FLAG)
CUFLAGS += --Werror all-warnings
endif

ifneq ($(OPENMP),0)
CFLAGS += $(OMP_FLAG)
LDFLAGS += $(OMP_FLAG)
endif

ifeq ($(DEBUG),1)
CFLAGS += $(strip $(CFLAGS_DEBUG))
CUFLAGS += $(strip $(CUFLAGS_DEBUG))
CUARFLAGS += $(strip $(CUARFLAGS_DEBUG))
LDFLAGS += $(strip $(LDFLAGS_DEBUG))
else
CFLAGS += $(strip $(CFLAGS_RELEASE))
CUFLAGS += $(strip $(CUFLAGS_RELEASE))
CUARFLAGS += $(strip $(CUARFLAGS_RELEASE))
LDFLAGS += $(strip $(LDFLAGS_RELEASE))
endif

AVX2_FLAG = -mavx2
AVX512_FLAG = -mavx512f
