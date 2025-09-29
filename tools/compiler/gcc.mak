# * Common C/C++ flags.

WARNINGS := -Wall -Wextra -Wpedantic -Werror

CCXXFLAGS_COMMON := $(WARNINGS) -MMD -fopenmp

CCXXFLAGS_DEBUG :=	-g \
										-O0 \
										-fno-omit-frame-pointer \
										--coverage \
										$(CCXXFLAGS_COMMON)

CCXXFLAGS_RELEASE = -O3 \
										-flto \
										-save-temps=obj \
										$(CCXXFLAGS_COMMON)

# C++ flags.
CXXFLAGS_COMMON := -std=c++23
CXXFLAGS_DEBUG := $(CXXFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CXXFLAGS_RELEASE := $(CXXFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# C flags
CFLAGS_COMMON := -std=c2x
CFLAGS_DEBUG := $(CFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CFLAGS_RELEASE := $(CFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# Linker flags.
LDFLAGS_COMMON :=
LDFLAGS_DEBUG := $(LDFLAGS_COMMON) --coverage
LDFLAGS_RELEASE := $(LDFLAGS_COMMON)

# On x64 builds, add ASan and UBSan for clang-cl. Not available for Arm64.
ifeq ($(ARCH),x64)
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
-o $(1) -MF $(1).d -fopt-info-optimized-missed-omp-vec=$(1).txt
endef

define output-paths-link
-o $(1) -fopt-info-optimized-missed-omp-vec=$(1).txt
endef
