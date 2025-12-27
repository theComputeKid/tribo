ifeq ($(OS)-$(LD),windows-lld)
LDFLAGS += -Wl,/machine:$(ARCH),/SUBSYSTEM:CONSOLE
LDFLAGS += -fuse-ld=lld
LD_WERROR_FLAG = -Wl,/WX
else ifeq ($(LD),apple)
LD_WERROR_FLAG = -Wl,-fatal_warnings
else ifeq ($(OS)-$(LD),macos-lld)
LD_WERROR_FLAG = -Wl,-fatal_warnings
LDFLAGS += -fuse-ld=lld
else ifeq ($(OS)-$(LD),linux-lld)
LD_WERROR_FLAG = -Wl,-fatal-warnings
LDFLAGS += -fuse-ld=lld
else ifeq ($(LD),ld)
LD_WERROR_FLAG = -Wl,--fatal-warnings
endif
