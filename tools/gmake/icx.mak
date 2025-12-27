LDFLAGS += -fuse-ld=lld

ifeq ($(OS),windows)
LDFLAGS += -Xlinker /machine:$(ARCH) -Xlinker /SUBSYSTEM:CONSOLE
endif

OMP_FLAG = -qopenmp
