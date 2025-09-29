# Check for spaces in the build directory path.
# Spaces in paths will break the build.
SINGLESPACE=$(subst ',,' ')
!IF "$(findstring $(SINGLESPACE),$(MAKEDIR))" != ""
!ERROR The build directory path contains a space: "$(MAKEDIR)". Move the project to a path without spaces.
!ENDIF

!INCLUDE detect-arch-nmake.mak

!IF "$(findstringi clang-cl,$(CC))" != ""
!INCLUDE clang-cl.mak
!ELSEIF "$(findstringi icx-cl,$(CC))" != ""
!INCLUDE icx-cl.mak
!ELSEIF "$(findstringi cl,$(CC))" != ""
!INCLUDE cl.mak
!ELSE
!ERROR Unsupported compiler: $(CC), expected cl, clang-cl or icx-cl
!ENDIF

!INCLUDE link.mak

!INCLUDE nvcc.mak
!INCLUDE cuda-nmake.mak

# Set flags based on build type.
!IF "$(DEBUG)" == "1"
CFLAGS = $(strip $(CFLAGS_DEBUG))
CXXFLAGS = $(strip $(CXXFLAGS_DEBUG))
LDFLAGS = $(strip $(LDFLAGS_DEBUG))
LINKFLAGS = $(strip $(LINKFLAGS_DEBUG))
CUFLAGS = $(strip $(CUFLAGS_DEBUG))
CULINKFLAGS = $(strip $(CULINKFLAGS_DEBUG))
ARFLAGS = $(strip $(ARFLAGS_DEBUG))
!ELSE
CFLAGS = $(strip $(CFLAGS_RELEASE))
CXXFLAGS = $(strip $(CXXFLAGS_RELEASE))
LDFLAGS = $(strip $(LDFLAGS_RELEASE))
LINKFLAGS = $(strip $(LINKFLAGS_RELEASE))
CUFLAGS = $(strip $(CUFLAGS_RELEASE))
CULINKFLAGS = $(strip $(CULINKFLAGS_RELEASE))
ARFLAGS = $(strip $(ARFLAGS_RELEASE))
!ENDIF

# ISA Flags: x64
ISA_FLAGS_AVX = /arch:AVX
ISA_FLAGS_AVX2 = /arch:AVX2
ISA_FLAGS_AVX512 = /arch:AVX512

# Used for deps generation.
CLDEPSFLAGS = /showIncludes /Zs /nologo /W0 /std:clatest /FC

!INCLUDE clang-tidy-nmake.mak
!INCLUDE clang-doc-nmake.mak
