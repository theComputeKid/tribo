OUT_EXT := .exe
LIB_EXT := .dll
OBJ_EXT := .obj

# GNU make sets default CC to 'cc' on Windows. Change to 'cl'.
ifeq ($(CC),cc)
CC := cl
endif

define delete-folder
if exist "$(1)" rmdir /s /q "$(1)"
endef

define delete-file
if exist "$(1)" del /q "$(1)"
endef

define print-file
type $(subst /,\,$(strip $(1)))
endef

# Try to see if we are in a VS dev command prompt if ARCH is not set.
ifeq ($(VSCMD_ARG_TGT_ARCH),x64)
ARCH ?= x64
else ifeq ($(VSCMD_ARG_TGT_ARCH),arm64)
ARCH ?= arm64
# Fall back to PROCESSOR_ARCHITECTURE.
else ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
ARCH ?= x64
else ifeq ($(PROCESSOR_ARCHITECTURE),ARM64)
ARCH ?= arm64
endif
