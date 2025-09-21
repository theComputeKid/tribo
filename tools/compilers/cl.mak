# * Common C/C++ flags.
WARNINGS = /W4 /WX /D_CRT_SECURE_NO_WARNINGS

CCXXFLAGS_COMMON =	/diagnostics:caret \
										/external:anglebrackets \
										/external:W0 \
										/nologo \
										/options:strict \
										/permissive- \
										/Zc:preprocessor \
										/Zf \
										/MP \
										/openmp \
										/Zi \
										/FAs \
										/FC \
										$(WARNINGS)

CCXXFLAGS_DEBUG =	/Od \
									/Zi \
									/MDd \
									$(CCXXFLAGS_COMMON)

CCXXFLAGS_RELEASE = /O2 \
										/FAs \
										/MD \
										/Qpar \
										/Qpar-report:1 \
										/Qvec-report:1 \
										/GL \
										$(CCXXFLAGS_COMMON)

# C++ flags.
CXXFLAGS_COMMON = /EHsc /std:c++latest /Zc:__cplusplus
CXXFLAGS_DEBUG = $(CXXFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CXXFLAGS_RELEASE = $(CXXFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# C flags
CFLAGS_COMMON = /std:clatest /Zc:__STDC__
CFLAGS_DEBUG = $(CFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CFLAGS_RELEASE = $(CFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# On x64 builds, add ASan and UBSan for clang-cl. Not available for Arm64.
!IF "$(ARCH)" == "x64"
CCXXFLAGS_DEBUG = /fsanitize=address /fsanitize-coverage=edge $(CCXXFLAGS_DEBUG)
LDFLAGS_DEBUG = /fsanitize=address /fsanitize-coverage=edge $(LDFLAGS_DEBUG)
!ENDIF
