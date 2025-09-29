# * Common C/C++ flags.
WARNINGS := /W4 /WX /D_CRT_SECURE_NO_WARNINGS

CCXXFLAGS_COMMON :=	/diagnostics:caret \
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

CCXXFLAGS_DEBUG :=	/Od \
									/Zi \
									/MDd \
									$(CCXXFLAGS_COMMON)

CCXXFLAGS_RELEASE := /O2 \
										/FAs \
										/MD \
										/Qpar \
										/Qpar-report:1 \
										/Qvec-report:1 \
										/GL \
										$(CCXXFLAGS_COMMON)

# C++ flags.
CXXFLAGS_COMMON := /EHsc /std:c++latest /Zc:__cplusplus
CXXFLAGS_DEBUG := $(CXXFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CXXFLAGS_RELEASE := $(CXXFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# C flags
CFLAGS_COMMON := /std:clatest /Zc:__STDC__
CFLAGS_DEBUG := $(CFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CFLAGS_RELEASE := $(CFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

LDFLAGS_COMMON := /nologo /FAs
LDFLAGS_DEBUG := $(LDFLAGS_COMMON)
LDFLAGS_RELEASE := $(LDFLAGS_COMMON) /GL

LINKFLAGS_COMMON := /NOLOGO /WX /NOIMPLIB /DEBUG:FULL #/TIME
LINKFLAGS_DEBUG := $(LINKFLAGS_COMMON)
LINKFLAGS_RELEASE := $(LINKFLAGS_COMMON) /INCREMENTAL:NO #/LTCG:STATUS /LTCG

# On x64 builds, add ASan and UBSan. Not available for Arm64.
ifeq ($(ARCH),x64)
CCXXFLAGS_DEBUG += /fsanitize=address /fsanitize-coverage=edge
LDFLAGS_DEBUG += /fsanitize=address /fsanitize-coverage=edge
endif

# Shared library flags.
SHARED_FLAG := /LD

# Output paths for compilation
define output-paths-compile
/Fo"$(subst /,\,$(strip $(1)))" \
/Fa"$(basename $(subst /,\,$(strip $(1)))).asm" \
/Fd"$(basename $(subst /,\,$(strip $(1)))).pdb"
endef

define output-paths-link
/Fe"$(subst /,\,$(strip $(1)))" \
/Fd"$(basename $(subst /,\,$(strip $(1)))).pdb" \
/link $(LINKFLAGS) /machine:$(ARCH)
endef
