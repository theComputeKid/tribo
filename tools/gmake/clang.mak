# Detect if Apple Clang.
ifeq ($(OS),macos)
CLANG_TYPE := $(shell $(CC) --version | head -n 1)
# Enable LLD and OpenMP for non-Apple Clang.
ifeq ($(findstring Apple,$(CLANG_TYPE)),)
LDFLAGS += -fuse-ld=lld
OPENMP := 1
endif
endif

ifeq ($(OS),windows)
LDFLAGS += -Xlinker /machine:$(ARCH) -Xlinker /SUBSYSTEM:CONSOLE
endif

OMP_FLAG = -fopenmp
