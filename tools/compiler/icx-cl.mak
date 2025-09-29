# * Common C/C++ flags.

WARNINGS = /W4 /WX -Wpedantic -D_CRT_SECURE_NO_WARNINGS

CCXXFLAGS_COMMON = /MD -fuse-ld=lld -g /FAs /nologo $(WARNINGS)

CCXXFLAGS_DEBUG = $(CCXXFLAGS_COMMON) \
									-fsanitize=address,undefined \
									/Od \
									/Zi

CCXXFLAGS_RELEASE = -O3 \
										/Qvec \
										/Qopt-report=0 \
										/Qopt-report-phase:vec,loop,openmp \
										/Qiopenmp \
										/Qopt-report-file:stdout \
										/Qipo \
										$(CCXXFLAGS_COMMON)

# Linker
LD_FLAGS_COMMON = /nologo -fuse-ld=lld
LDFLAGS_RELEASE = -Qipo \
									-fuse-ld=lld \
									/Qopt-report=2 \
									/Qopt-report-phase:vec,loop,openmp \
									$(LD_FLAGS_COMMON)

LDFLAGS_DEBUG = -fsanitize=address,undefined $(LD_FLAGS_COMMON)

# C++ flags.
CXXFLAGS_COMMON = /EHsc /std:c++latest /Zc:__cplusplus
CXXFLAGS_DEBUG = $(CXXFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CXXFLAGS_RELEASE = $(CXXFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# C flags.
CFLAGS_COMMON = -Xclang -std=c23 /Zc:__STDC__
CFLAGS_DEBUG = $(CFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CFLAGS_RELEASE = $(CFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# Shared library flags.
SHARED_FLAG = /LD

# Output
OBJ_OUT_FLAG = -o
