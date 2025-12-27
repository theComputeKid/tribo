ifndef ARCH
	ifeq ($(OS),linux)
		UNAME_M := $(shell uname -m)
		ifeq ($(UNAME_M),x86_64)
			ARCH := x64
		else ifeq ($(UNAME_M),i686)
			ARCH := x86
		else ifeq ($(UNAME_M),aarch64)
			ARCH := arm64
		else
$(error Unsupported architecture: $(UNAME_M), expected x86, x64, or aarch64.)
		endif
	else ifeq ($(OS),macos)
		ARCH := arm64
	else ifeq ($(OS),windows)
		ifdef VSCMD_ARG_TGT_ARCH
			ARCH := $(VSCMD_ARG_TGT_ARCH)
		else ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
			ARCH := x64
		else ifeq ($(PROCESSOR_ARCHITEW6432),ARM64)
			ARCH := arm64
		else ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
			ARCH := x64
		else ifeq ($(PROCESSOR_ARCHITECTURE),x86)
			ARCH := x86
		else ifeq ($(PROCESSOR_ARCHITECTURE),ARM64)
			ARCH := arm64
		else
$(error Unsupported PROCESSOR_ARCHITECTURE: $(PROCESSOR_ARCHITECTURE). Expected: AMD64, x86, or ARM64.)
		endif
	endif
endif

ALLOWED_ARCH := x64 x86 arm64
ifeq ($(filter $(ARCH),$(ALLOWED_ARCH)),)
$(error Unsupported Architecture: $(ARCH). Expected: $(ALLOWED_ARCH))
endif
