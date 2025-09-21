# * Common C/C++ flags.

WARNINGS = -Wall -Wextra -Wpedantic -Werror

CCXXFLAGS_COMMON = $(WARNINGS) -MMD -fopenmp -P

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
										-foptimization-record-file=$@.opt.yaml \
										$(CCXXFLAGS_COMMON)

# C++ flags.
CXXFLAGS_COMMON = -std=c++23
CXXFLAGS_DEBUG = $(CXXFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CXXFLAGS_RELEASE = $(CXXFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# C flags
CFLAGS_COMMON = -std=c23
CFLAGS_DEBUG = $(CFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CFLAGS_RELEASE = $(CFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# Linker flags.
LDFLAGS_COMMON = -fuse-ld=lld
LDFLAGS_DEBUG = $(LDFLAGS_COMMON) --coverage
LDFLAGS_RELEASE = $(LDFLAGS_COMMON) \
									-O3 \
									-flto \
									-save-temps=obj \
									-Rpass-analysis=loop-vectorize -Rpass-analysis=loop-unroll \
									-Rpass=loop-vectorize -Rpass=loop-unroll \
									-Rpass-missed=loop-vectorize -Rpass-missed=loop-unroll \
									-fsave-optimization-record \
									-foptimization-record-passes=loop-* \
									-foptimization-record-file=$(TMP_DIR)/$(basename $(notdir $@))

# On x64 builds, add ASan and UBSan for clang-cl. Not available for Arm64.
ifeq ($(ARCH),x64)
CCXXFLAGS_DEBUG += -fsanitize=address,undefined
LDFLAGS_DEBUG += -fsanitize=address,undefined
endif

TIDY_PATH = run-clang-tidy
