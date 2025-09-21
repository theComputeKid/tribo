# * Common C/C++ flags.

WARNINGS = -Wall -Wextra -Wpedantic -Werror

CCXXFLAGS_COMMON = $(WARNINGS) -MMD -P -fPIC

CCXXFLAGS_DEBUG =	-g \
									-O0 \
									-fno-omit-frame-pointer \
									--coverage \
									$(CCXXFLAGS_COMMON)

CCXXFLAGS_RELEASE =	-O3 \
										-ipo \
										-vec \
										-qopt-report=2 \
										-qopt-report-phase=vec,loop,openmp \
										-qopenmp \
										-qopt-report-file=$@.txt \
										-save-temps=obj \
										$(CCXXFLAGS_COMMON)

# Linker
LDFLAGS_COMMON = -fuse-ld=lld

LDFLAGS_RELEASE = -ipo \
									-qopt-report=2 \
									-qopt-report-phase=vec,loop,openmp \
									-qopt-report-file=$(TMP_DIR)/$(basename $(notdir $@)).opt.txt \
									-save-temps=obj \
									$(LDFLAGS_COMMON)

LDFLAGS_DEBUG = $(LDFLAGS_COMMON) -fsanitize=address,undefined --coverage

# C++ flags.
CXXFLAGS_COMMON = -std=c++23
CXXFLAGS_DEBUG = $(CXXFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CXXFLAGS_RELEASE = $(CXXFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# C flags.
CFLAGS_COMMON = -std=c23
CFLAGS_DEBUG = $(CFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CFLAGS_RELEASE = $(CFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

TIDY_PATH = run-clang-tidy
