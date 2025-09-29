# * Common C/C++ flags.

WARNINGS = -Wall -Wextra -Werror

CCXXFLAGS_COMMON = $(WARNINGS) -MMD -fopenmp

CCXXFLAGS_DEBUG = -g \
									-O0 \
									-fno-omit-frame-pointer \
									--coverage \
									$(CCXXFLAGS_COMMON)

CCXXFLAGS_RELEASE = -O3 \
										-save-temps=obj \
										-fopt-info-optimized-missed-omp-vec=$@.txt \
										$(CCXXFLAGS_COMMON)

# C++ flags.
CXXFLAGS_COMMON = -std=c++23
CXXFLAGS_DEBUG = $(CXXFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CXXFLAGS_RELEASE = $(CXXFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# C flags.
CFLAGS_COMMON = -std=c23
CFLAGS_DEBUG = $(CFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CFLAGS_RELEASE = $(CFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# Linker flags.
LDFLAGS_DEBUG = $(LDFLAGS_COMMON) --coverage
