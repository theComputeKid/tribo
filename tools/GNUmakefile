# Main project makefile. For use with GNU Make on Linux, MacOS and Windows.

include tools/gmake/setup.mak
include tools/files.mk

PRJ_NAME = tribo

BIN_DIR = bin
SRC_DIR = src
TMP_DIR = tmp

INC_DIR = -I$(SRC_DIR)/include

# Source files.
SRCS_CLI = $(addprefix $(SRC_DIR)/cli/,$(SRC_CLI))
SRCS_BASE = $(addprefix $(SRC_DIR)/base/,$(SRC_BASE))
SRCS_UTILS = $(addprefix $(SRC_DIR)/utils/,$(SRC_UTILS))
SRCS_AVX = $(addprefix $(SRC_DIR)/avx/,$(SRC_AVX))
SRCS_NEON = $(addprefix $(SRC_DIR)/neon/,$(SRC_NEON))

# Output objects.
OBJ_cli = $(patsubst $(SRC_DIR)/%.c,$(TMP_DIR)/%.o,$(SRCS_CLI))
OBJ_base = $(patsubst $(SRC_DIR)/%.c,$(TMP_DIR)/%.o,$(SRCS_BASE))
OBJ_utils = $(patsubst $(SRC_DIR)/%.c,$(TMP_DIR)/%.o,$(SRCS_UTILS))
OBJ_avx = $(patsubst $(SRC_DIR)/%.c,$(TMP_DIR)/%.o,$(SRCS_AVX))
OBJ_neon = $(patsubst $(SRC_DIR)/%.c,$(TMP_DIR)/%.o,$(SRCS_NEON))
OBJ_ALL = $(OBJ_cli) $(OBJ_base) $(OBJ_utils) $(OBJ_avx) $(OBJ_neon)
DEPS = $(OBJ_ALL:.o=.d)

# Output binaries.
out_cli = $(BIN_DIR)/$(PRJ_NAME)-cli$(EXE_EXT)
OUT_base = $(BIN_DIR)/$(DLL_PRE)$(PRJ_NAME)-base$(DLL_EXT)
out_utils = $(BIN_DIR)/$(DLL_PRE)$(PRJ_NAME)-utils$(DLL_EXT)
OUT_avx = $(BIN_DIR)/$(DLL_PRE)$(PRJ_NAME)-avx$(DLL_EXT)
OUT_neon = $(BIN_DIR)/$(DLL_PRE)$(PRJ_NAME)-neon$(DLL_EXT)
OUT_LIBS = $(out_utils) $(OUT_base) $(OUT_avx) $(OUT_neon)

OUT_EXE = $(out_cli)
OUT_ALL = $(OUT_EXE) $(OUT_LIBS)

TARGETS = cli utils base

ifeq ($(ARCH),x64)
TARGETS += avx
else ifeq ($(ARCH),arm64)
TARGETS += neon
endif

TMP_DIRS = $(patsubst %,$(TMP_DIR)/%/,$(TARGETS))

# Default target.
all: $(TARGETS)

# Set compiler flags for different object targets.
$(OBJ_base) $(OBJ_neon) $(OBJ_avx): CFLAGS += -DTRIBO_EXPORT
$(OBJ_utils): CFLAGS += -DTRIBO_UTILS_EXPORT
$(OBJ_avx): CFLAGS += $(AVX_FLAG)

# Define target dependencies.
$(out_cli) $(OUT_base) $(OUT_avx) $(OUT_neon): $(out_utils)

# Create necessary directories.
$(BIN_DIR) $(TMP_DIRS):
	$(call MKDIR,$@)

clean:
	$(call RMDIR,$(BIN_DIR))
	$(call RMDIR,$(TMP_DIR))

rebuild: clean
	@$(MAKE) --no-print-directory all

run help version:
ifeq ($(OS),linux)
	$(out_cli) --$@ --verbosity=2 --input=examples/simple.ini --output=$(TMP_DIR)/output.txt --plugin=$(OUT_base)
else ifeq ($(OS),windows)
	$(out_cli) --$@ --verbosity=2 --input=examples/simple.ini --output=$(TMP_DIR)/output.txt --plugin=$(OUT_base)
else ifeq ($(OS),macos)
	DYLD_LIBRARY_PATH=$(BIN_DIR) $(out_cli) --$@ --verbosity=2 --input=examples/simple.ini --output=$(TMP_DIR)/output.txt --plugin=$(OUT_base)
endif

-include $(DEPS)

.SECONDEXPANSION:

# Phony targets for each build target.
# e.g. expands to: base: $(OUT_base)
$(TARGETS): $$(OUT_$$@)

# Shared library linking rules.
# e.g. expands to: bin/libtribo-base.so: $(OBJ_base) | bin
# Add other dependent libs as needed.
$(OUT_LIBS): $$(OBJ_$$(patsubst $(BIN_DIR)/$(DLL_PRE)$(PRJ_NAME)-%$(DLL_EXT),%,$$@)) | $(BIN_DIR)
	$(CC) -shared $(LDFLAGS) $(patsubst %$(DLL_EXT),%$(LIB_EXT),$^) -o $@

# Executable linking rules.
# e.g. expands to: bin/tribo-cli: $(OBJ_cli) | bin
# Add other dependent libs as needed.
$(OUT_EXE): $$(OBJ_$$(patsubst $(BIN_DIR)/$(PRJ_NAME)-%$(EXE_EXT),%,$$@)) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $(patsubst %$(DLL_EXT),%$(LIB_EXT),$^) -o $@

# Object compilation rules.
$(TMP_DIR)/%.o: $(SRC_DIR)/%.c | $$(dir $$(@))
ifdef TIDY
	$(TIDY) $< -quiet -config-file=.clang-tidy -- $(INC_DIR) $(CFLAGS)
endif
	$(CC) -c $< -o $@ $(INC_DIR) $(CFLAGS)
