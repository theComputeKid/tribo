# Set target architecture.

# First see if the user has provided the arch to build for.
!IF "$(ARCH)" == "x64"
CLANG_ARCH = x86_64
!ELSEIF "$(ARCH)" == "arm64"
CLANG_ARCH = aarch64
# Try to see if we are in a VS dev command prompt.
!ELSEIF "$(VSCMD_ARG_TGT_ARCH)" == "x64"
ARCH = x64
CLANG_ARCH = x86_64
!ELSEIF "$(VSCMD_ARG_TGT_ARCH)" == "arm64"
ARCH = arm64
CLANG_ARCH = aarch64
# Fall back to PROCESSOR_ARCHITECTURE.
!ELSEIF "$(PROCESSOR_ARCHITECTURE)" == "AMD64"
ARCH = x64
CLANG_ARCH = x86_64
!ELSEIF "$(PROCESSOR_ARCHITECTURE)" == "ARM64"
ARCH = arm64
CLANG_ARCH = aarch64
!ELSE
!ERROR Unsupported architecture: $(PROCESSOR_ARCHITECTURE), expected AMD64 or ARM64.
!ENDIF
