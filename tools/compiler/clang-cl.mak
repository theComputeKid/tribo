ifeq ($(ARCH),x64)
CLANG_ARCH := x86_64
else ifeq ($(ARCH),arm64)
CLANG_ARCH := aarch64
endif

WARNINGS = /W4 /WX -Wpedantic -D_CRT_SECURE_NO_WARNINGS /external:W0

CCXXFLAGS_COMMON =	/MD \
										-fuse-ld=lld \
										/openmp \
										/Zi \
										-target $(CLANG_ARCH)-pc-windows-msvc \
										$(WARNINGS)

CCXXFLAGS_DEBUG = /Od /Zi $(CCXXFLAGS_COMMON)

CCXXFLAGS_RELEASE = -Xclang -O3 /Qvec -flto /FAs $(CCXXFLAGS_COMMON)

LDFLAGS_COMMON = -fuse-ld=lld -target $(CLANG_ARCH)-pc-windows-msvc /MD
LDFLAGS_DEBUG = $(LDFLAGS_COMMON)
LDFLAGS_RELEASE = $(LDFLAGS_COMMON)

LINKFLAGS_COMMON = /NOLOGO /WX /NOIMPLIB /DEBUG:FULL #/TIME
LINKFLAGS_DEBUG = $(LINKFLAGS_COMMON)
LINKFLAGS_RELEASE = $(LINKFLAGS_COMMON) /INCREMENTAL:NO #/LTCG:STATUS /LTCG

# C++ flags.
CXXFLAGS_COMMON = /EHsc /std:c++latest /Zc:__cplusplus
CXXFLAGS_DEBUG = $(CXXFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CXXFLAGS_RELEASE = $(CXXFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# C flags
CFLAGS_COMMON = -Xclang -std=c23 /Zc:__STDC__
CFLAGS_DEBUG = $(CFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CFLAGS_RELEASE = $(CFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# On x64 builds, add ASan and UBSan. Not available for Arm64.
ifeq ($(ARCH),x64)
CCXXFLAGS_DEBUG += -fsanitize=address,undefined
LDFLAGS_DEBUG += -fsanitize=address,undefined
endif

# Shared library flags.
SHARED_FLAG = /LD

# Output paths for compilation
define output-paths-compile
/Fo"$(subst /,\,$(strip $(1)))" \
/Fa"$(basename $(subst /,\,$(strip $(1)))).asm" \
/Fd"$(basename $(subst /,\,$(strip $(1)))).pdb"
endef

define output-paths-link
/Fe"$(subst /,\,$(strip $(1)))" \
/Fd"$(basename $(subst /,\,$(strip $(1)))).pdb" \
/link $(LINKFLAGS)
endef
