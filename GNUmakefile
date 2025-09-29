
# GMake-compatible makefile.
PRJ_NAME := tribo

# Shared Library flags.
EXPORT_MACRO := -DTRIBO_EXPORT

BIN_DIR := bin
TMP_DIR := tmp
HELP_FILE := tools/help.txt

# On Windows, OS is defined by default to Windows_NT. Otherwise, detect OS.
OS ?=$(shell uname -s) # Possible values: Windows_NT, Linux, Darwin
OS :=$(strip $(OS))

ifneq ($(filter-out Windows_NT Linux Darwin,$(OS)),)
$(error OS must be set to Windows_NT, Linux, or Darwin)
endif

ifeq ($(OS),Windows_NT)
include tools/windows.mak
else
include tools/unix.mak
endif

ifneq ($(filter-out x64 arm64,$(ARCH)),)
$(error ARCH must be set to x64 or arm64)
endif

include tools/compiler-detection.mak
include tools/compiler/$(COMPILER_ID).mak
include tools/compiler/nvcc.mak
include tools/config.mak

# Source directories.
SOURCES_DIR := src
SOURCES_DIR_APP := $(SOURCES_DIR)/app
SOURCES_DIR_BASE := $(SOURCES_DIR)/base
SOURCES_DIR_CUDA := $(SOURCES_DIR)/cuda
SOURCES_DIR_UTILS := $(SOURCES_DIR)/utils

# Source files.
SOURCES_APP := $(wildcard $(SOURCES_DIR_APP)/*.c)
SOURCES_BASE := $(wildcard $(SOURCES_DIR_BASE)/*.c)
SOURCES_CUDA := $(wildcard $(SOURCES_DIR_CUDA)/*.cu)
SOURCES_UTILS := $(wildcard $(SOURCES_DIR_UTILS)/*.c)

# Include directories.
INC_DIR := -I$(SOURCES_DIR)/include

# Create corresponding object directories.
OBJECTS_DIR_APP := $(TMP_DIR)/$(SOURCES_DIR_APP)
OBJECTS_DIR_BASE := $(TMP_DIR)/$(SOURCES_DIR_BASE)
OBJECTS_DIR_CUDA := $(TMP_DIR)/$(SOURCES_DIR_CUDA)
OBJECTS_DIR_UTILS := $(TMP_DIR)/$(SOURCES_DIR_UTILS)
OBJECTS_DIR_ALL := $(OBJECTS_DIR_APP) $(OBJECTS_DIR_BASE) $(OBJECTS_DIR_CUDA) $(OBJECTS_DIR_UTILS)

# Create necessary output folders.
ifeq ($(OS),Windows_NT)
MAKE_FOLDERS := $(foreach dir,$(OBJECTS_DIR_ALL) $(BIN_DIR),$(shell if not exist "$(dir)" mkdir "$(dir)"))
else
MAKE_FOLDERS := $(shell mkdir -p $(OBJECTS_DIR_ALL) $(BIN_DIR))
endif

# Create corresponding object files.
OBJECTS_APP := $(SOURCES_APP:%.c=$(TMP_DIR)/%$(OBJ_EXT))
OBJECTS_BASE := $(SOURCES_BASE:%.c=$(TMP_DIR)/%$(OBJ_EXT))
OBJECTS_CUDA := $(SOURCES_CUDA:%.cu=$(TMP_DIR)/%$(OBJ_EXT))
OBJECTS_UTILS := $(SOURCES_UTILS:%.c=$(TMP_DIR)/%$(OBJ_EXT))
OBJECTS_ALL := $(OBJECTS_APP) $(OBJECTS_BASE) $(OBJECTS_CUDA) $(OBJECTS_UTILS)

# Create corresponding dependency files.
DEPS_ALL := $(addsuffix .d,$(OBJECTS_ALL))

# Output files.
OUT_APP := $(BIN_DIR)/$(PRJ_NAME)$(OUT_EXT)
OUT_LIB := $(BIN_DIR)/lib$(PRJ_NAME)
OUT_BASE := $(OUT_LIB)-base$(LIB_EXT)
OUT_CUDA := $(OUT_LIB)-cuda$(LIB_EXT)

# Config to run example.
include tools/example.mak

# Meta rule for builds that need only a compiler for the CPU.
cpu: app base
	@echo Built: $^

# Default target.
all: app base cuda
	@echo Built: $^

# App meta rule.
app: $(OUT_APP)
	@echo Built: $@

# App link rule.
$(OUT_APP): $(OBJECTS_APP) $(OBJECTS_UTILS)
	$(CC) $(LDFLAGS) $^ $(call output-paths-link,$@)

# App compile rule.
$(OBJECTS_DIR_APP)/%$(OBJ_EXT): $(SOURCES_DIR_APP)/%.c
	$(CC) -c $(INC_DIR) $(CFLAGS) $< $(call output-paths-compile,$@)

# Utils compile rule.
$(OBJECTS_DIR_UTILS)/%$(OBJ_EXT): $(SOURCES_DIR_UTILS)/%.c
	$(CC) -c $(INC_DIR) $(CFLAGS) $< $(call output-paths-compile,$@)

# Base meta rule.
base: $(OUT_BASE)
	@echo Built: $@

# Base link rule.
$(OUT_BASE): $(OBJECTS_BASE)
	$(CC) $(LDFLAGS) $(SHARED_FLAG) $^ $(call output-paths-link,$@) $(LIBS)

# Base compile rule.
$(OBJECTS_DIR_BASE)/%$(OBJ_EXT): $(SOURCES_DIR_BASE)/%.c
	$(CC) -c $(INC_DIR) $(EXPORT_MACRO) $(CFLAGS) $< $(call output-paths-compile,$@)

# CUDA meta rule.
cuda: $(OUT_CUDA)
	@echo Built: $@

# CUDA link rule.
$(OUT_CUDA): $(OBJECTS_CUDA)
	$(NVCC) -shared $(CULINKFLAGS) --keep-dir $(OBJECTS_DIR_CUDA) $^ $(call output-paths-link-nvcc,$@)

# CUDA compile rule.
$(OBJECTS_DIR_CUDA)/%$(OBJ_EXT): $(SOURCES_DIR_CUDA)/%.cu
	$(NVCC) -c $(INC_DIR) $(EXPORT_MACRO) $(CUFLAGS) --keep-dir $(OBJECTS_DIR_CUDA) $< $(call output-paths-compile-nvcc,$@)

clean:
	$(call delete-folder,$(BIN_DIR))
	$(call delete-folder,$(TMP_DIR))

help:
	@$(call print-file,$(HELP_FILE))

rebuild: clean
	$(MAKE)

run: app
	$(EXAMPLE_RUN_CMD)

# Add dependencies.
-include $(DEPS_ALL)
