override CC := $(shell brew --prefix llvm)/bin/clang
override CXX := $(shell brew --prefix llvm)/bin/clang++

# Common C/C++ flags.
WARNINGS = -Wall -Wextra -Werror

CCXXFLAGS_COMMON = $(WARNINGS) -MMD -fopenmp

CCXXFLAGS_DEBUG =	-g \
									-O0 \
									-fno-omit-frame-pointer \
									--coverage \
									$(CCXXFLAGS_COMMON)

CCXXFLAGS_RELEASE = -O3 \
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

# Linker flags - executable.
LDFLAGS_COMMON = -fuse-ld=lld
LDFLAGS_DEBUG = $(LDFLAGS_COMMON) --coverage
LDFLAGS_RELEASE = $(LDFLAGS_COMMON)
