MAKEFILE_DIR = $(dir $(lastword $(MAKEFILE_LIST)))

include $(MAKEFILE_DIR)/detect-arch-gmake.mak

# Linux compiler support.
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
include $(MAKEFILE_DIR)/nvcc.mak
include $(MAKEFILE_DIR)/cuda-gmake.mak
endif

# MacOS compiler support.
ifeq ($(OS),macos)
ifeq ($(CC), cc)
include $(MAKEFILE_DIR)/clang-apple.mak
else ifneq ($(findstring gcc-,$(CC)),) # Actual GCC on MacOS has a version.
include $(MAKEFILE_DIR)/gcc-brew.mak
else ifeq ($(CC), clang)
include $(MAKEFILE_DIR)/clang-brew.mak
else ifeq ($(CC), gcc) # GCC on MacOS is an alias to clang.
include $(MAKEFILE_DIR)/clang-apple.mak
endif
CUDA_SUPPORT = 0 # CUDA is not supported on MacOS.
endif

include $(MAKEFILE_DIR)/clang-tidy-gmake.mak
include $(MAKEFILE_DIR)/clang-doc-gmake.mak

# Set flags based on build type.
ifeq ($(DEBUG),1)
CFLAGS = $(strip $(CFLAGS_DEBUG))
CXXFLAGS = $(strip $(CXXFLAGS_DEBUG))
LDFLAGS = $(strip $(LDFLAGS_DEBUG))
CUFLAGS = $(strip $(CUFLAGS_DEBUG))
CULINKFLAGS = $(strip $(CULINKFLAGS_DEBUG))
else
CFLAGS = $(strip $(CFLAGS_RELEASE))
CXXFLAGS = $(strip $(CXXFLAGS_RELEASE))
LDFLAGS = $(strip $(LDFLAGS_RELEASE))
CUFLAGS = $(strip $(CUFLAGS_RELEASE))
CULINKFLAGS = $(strip $(CULINKFLAGS_RELEASE))
endif

# ISA Flags: x64
ISA_FLAGS_AVX = -mavx
ISA_FLAGS_AVX2 = -mavx2
ISA_FLAGS_AVX512 = -mavx512f
