WARNINGS = /W4 /WX -Wpedantic -D_CRT_SECURE_NO_WARNINGS /external:W0

CCXXFLAGS_COMMON =	/MD \
										-fuse-ld=lld \
										/openmp \
										/Zi \
										-target $(CLANG_ARCH)-pc-windows-msvc \
										$(WARNINGS)

CCXXFLAGS_DEBUG = /Od /Zi $(CCXXFLAGS_COMMON)

CCXXFLAGS_RELEASE = -Xclang -O3 /Qvec -flto /FAs $(CCXXFLAGS_COMMON)

LDFLAGS_COMMON = -fuse-ld=lld -target $(CLANG_ARCH)-pc-windows-msvc
LDFLAGS_DEBUG = $(LDFLAGS_COMMON)
LDFLAGS_RELEASE = $(LDFLAGS_COMMON)

# C++ flags.
CXXFLAGS_COMMON = /EHsc /std:c++latest /Zc:__cplusplus
CXXFLAGS_DEBUG = $(CXXFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CXXFLAGS_RELEASE = $(CXXFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# C flags
CFLAGS_COMMON = -Xclang -std=c23 /Zc:__STDC__
CFLAGS_DEBUG = $(CFLAGS_COMMON) $(CCXXFLAGS_DEBUG)
CFLAGS_RELEASE = $(CFLAGS_COMMON) $(CCXXFLAGS_RELEASE)

# On x64 builds, add ASan and UBSan for clang-cl. Not available for Arm64.
!IF "$(ARCH)" == "x64"
CCXXFLAGS_DEBUG = -fsanitize=address,undefined $(CCXXFLAGS_DEBUG)
LDFLAGS_DEBUG = -fsanitize=address,undefined $(LDFLAGS_DEBUG)
!ENDIF

AR = llvm-lib
