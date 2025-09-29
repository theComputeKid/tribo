# * Common C/C++ flags.

WARNINGS = /W4 /WX -Wpedantic -D_CRT_SECURE_NO_WARNINGS

CCXXFLAGS_COMMON = /MD -fuse-ld=lld -g /FAs /nologo $(WARNINGS)

CCXXFLAGS_DEBUG = 	$(CCXXFLAGS_COMMON) \
										-fsanitize=address,undefined \
										/Od \
										/Zi

CCXXFLAGS_RELEASE = 	-O3 \
											/Qvec \
											/Qopt-report=0 \
											/Qopt-report-phase:vec,loop,openmp \
											/Qiopenmp \
											/Qopt-report-file:stdout \
											/Qipo \
											$(CCXXFLAGS_COMMON)
# Linker
COMPLINKFLAGS_RELEASE = 	-Qipo \
													-fuse-ld=lld \
													/Qopt-report=2 \
													/Qopt-report-phase:vec,loop,openmp \
													/Qopt-report-file:$@.opt.txt \
													/nologo

COMPLINKFLAGS_DEBUG = 		-fuse-ld=lld /nologo -fsanitize=address,undefined

# C++ flags.
CXXFLAGS_COMMON = /EHsc /std:c++latest /Zc:__cplusplus
CXXFLAGS_DEBUG = $(CXXFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CXXFLAGS_RELEASE = $(CXXFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# C flags.
CFLAGS_COMMON = -Xclang -std=c23 /Zc:__STDC__
CFLAGS_DEBUG = $(CFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CFLAGS_RELEASE = $(CFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# Compiler flags used for linking.
COMPLINKFLAGS_DEBUG =  $(COMPLINKFLAGS_DEBUG)
COMPLINKFLAGS_RELEASE = $(COMPLINKFLAGS_RELEASE)
