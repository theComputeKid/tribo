CFLAGS_COMMON = -Wpedantic /options:strict /openmp
CFLAGS_DEBUG = /Od /Zi /MD -fsanitize=address,undefined $(CFLAGS_COMMON)
CFLAGS_RELEASE = -Xclang -O3 /FAs /MD -flto $(CFLAGS_COMMON)

AR = llvm-lib

RUNTIME_LIB_DEBUG = msvcrt.lib
RUNTIME_LIB_RELEASE = msvcrt.lib

LDFLAGS_COMMON = -fuse-ld=lld
LDFLAGS_DEBUG = -fsanitize=address,undefined $(LDFLAGS_COMMON)
LDFLAGS_RELEASE = $(LDFLAGS_COMMON)
