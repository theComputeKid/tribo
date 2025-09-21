# Include the appropriate compiler settings.
!IFNDEF ARCH
!ERROR ARCH not set.
!ENDIF

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

# Set flags based on build type.
!IF "$(DEBUG)" == "1"
CFLAGS = $(strip $(CFLAGS_DEBUG))
CXXFLAGS = $(strip $(CXXFLAGS_DEBUG))
LDFLAGS = $(strip $(LDFLAGS_DEBUG))
LINKFLAGS = $(strip $(LINKFLAGS_DEBUG))
!ELSE
CFLAGS = $(strip $(CFLAGS_RELEASE))
CXXFLAGS = $(strip $(CXXFLAGS_RELEASE))
LDFLAGS = $(strip $(LDFLAGS_RELEASE))
LINKFLAGS = $(strip $(LINKFLAGS_RELEASE))
!ENDIF

# ISA Flags: x64
ISA_FLAGS_AVX = /arch:AVX
ISA_FLAGS_AVX2 = /arch:AVX2
ISA_FLAGS_AVX512 = /arch:AVX512

# Used for clang tidy and compile_commands.json generation.
CTIDYFLAGS = 	/W4 /WX -Wpedantic -D_CRT_SECURE_NO_WARNINGS /external:W0 \
							-Xclang -std=c23

# Used for deps generation.
CLDEPSFLAGS = /showIncludes /Zs /nologo /W0 /std:clatest /FC

# If LLVM_DIR is set, use the clang-tidy from there, which probably also has
# run-clang-tidy for parallel processing. Otherwise, fall back to sequential
# clang-tidy.
!IFNDEF LLVM_DIR
CLANGTIDY_CALL = clang-tidy
!ELSE
CLANGTIDY = $(LLVM_DIR:"=)\bin\clang-tidy.exe
RUNCLANGTIDY = $(LLVM_DIR:"=)\bin\run-clang-tidy
CLANGTIDY_CALL = python "$(RUNCLANGTIDY)" -clang-tidy-binary "$(CLANGTIDY)" -quiet -j$(NUMBER_OF_PROCESSORS)
!ENDIF
