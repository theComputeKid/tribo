ifeq ($(ARCH),x64)
CLANG_ARCH := x86_64
else ifeq ($(ARCH),arm64)
CLANG_ARCH := aarch64
endif

ifeq ($(OS),Windows_NT)
CLANG_ARCH := -target $(CLANG_ARCH)-pc-windows-msvc
USE_LLD_FLAG := -fuse-ld=lld
OPENMP ?= 1
else ifeq ($(OS),Darwin)
CLANG_ARCH := -target arm64-apple-darwin
OPENMP ?= 0
else ifeq ($(OS),Linux)
CLANG_ARCH := -target $(CLANG_ARCH)-pc-linux-gnu
OPENMP ?= 1
USE_LLD_FLAG := -fuse-ld=lld
endif

ifeq ($(OPENMP),1)
OPENMP_FLAG := -fopenmp
endif

WARNINGS := -Wall -Wextra -Wpedantic -Werror -Wno-gnu-line-marker
ifeq ($(OS),Windows_NT)
WARNINGS += -D_CRT_SECURE_NO_WARNINGS
endif

CCXXFLAGS_COMMON := $(WARNINGS) -MMD $(OPENMP_FLAG) $(CLANG_ARCH)

CCXXFLAGS_DEBUG =	-g \
									-O0 \
									-fno-omit-frame-pointer \
									--coverage \
									$(CCXXFLAGS_COMMON)

CCXXFLAGS_RELEASE =	-O3 \
										-flto \
										-Rpass-analysis=loop-vectorize -Rpass-analysis=loop-unroll \
										-Rpass=loop-vectorize -Rpass=loop-unroll \
										-Rpass-missed=loop-vectorize -Rpass-missed=loop-unroll \
										-fsave-optimization-record \
										-foptimization-record-passes=loop-* \
										-save-temps=obj \
										$(CCXXFLAGS_COMMON)

# C++ flags.
CXXFLAGS_COMMON := -std=c++23
CXXFLAGS_DEBUG := $(CXXFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CXXFLAGS_RELEASE := $(CXXFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# C flags
CFLAGS_COMMON := -std=c23
CFLAGS_DEBUG := $(CFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CFLAGS_RELEASE := $(CFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# Linker flags.
LDFLAGS_COMMON := $(USE_LLD_FLAG) $(CLANG_ARCH)
LDFLAGS_DEBUG := $(LDFLAGS_COMMON) --coverage
LDFLAGS_RELEASE := $(LDFLAGS_COMMON) \
									-O3 \
									-flto \
									-save-temps=obj \
									-Rpass-analysis=loop-vectorize -Rpass-analysis=loop-unroll \
									-Rpass=loop-vectorize -Rpass=loop-unroll \
									-Rpass-missed=loop-vectorize -Rpass-missed=loop-unroll \
									-fsave-optimization-record \
									-foptimization-record-passes=loop-*

# On x64 builds, add ASan and UBSan. Not available for non-MacOS Arm64.
ifeq ($(ARCH),x64)
CCXXFLAGS_DEBUG += -fsanitize=address,undefined
LDFLAGS_DEBUG += -fsanitize=address,undefined
endif

ifeq ($(OS),Darwin)
CCXXFLAGS_DEBUG += -fsanitize=address,undefined
LDFLAGS_DEBUG += -fsanitize=address,undefined
endif

# ISA Flags: x64
ISA_FLAGS_AVX := -mavx
ISA_FLAGS_AVX2 := -mavx2
ISA_FLAGS_AVX512 := -mavx512f

# Shared library flags.
SHARED_FLAG := -shared

# Output paths for compilation
define output-paths-compile
-o $(1) -MF $(1).d
endef

define output-paths-link
-o $(1) -foptimization-record-file=$(basename $(strip $(1))).opt
endef
