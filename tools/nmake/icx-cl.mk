CFLAGS_COMMON = -Wpedantic /Qiopenmp
CFLAGS_DEBUG = -fsanitize=address,undefined /MD $(CFLAGS_COMMON)
CFLAGS_RELEASE = -Xclang -O3 /Qipo /MD $(CFLAGS_COMMON)

LDFLAGS_COMMON = -fuse-ld=lld
LDFLAGS_DEBUG = -fsanitize=address,undefined $(LDFLAGS_COMMON)
LDFLAGS_RELEASE = $(LDFLAGS_COMMON)
