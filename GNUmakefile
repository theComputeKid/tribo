# Main project makefile. For use with GNU Make on Linux, MacOS and Windows.

include tools/gmake/setup.mak
include tools/files.mk

# Output binaries.
# out_cli = bin/tribo-cli$(EXE_EXT)
# OUT_BASE = bin/libtribo-base$(DLL_EXT)
# out_utils = bin/libtribo-utils$(DLL_EXT)
# out_avx2 = bin/libtribo-avx2$(DLL_EXT)
# OUT_NEON = bin/libtribo-neon$(DLL_EXT)
# OUT_LIBS = $(out_utils) $(OUT_BASE) $(out_avx2) $(OUT_NEON)

TARGETS = cli utils

ifeq ($(ARCH),x64)
TARGETS += avx2
else ifeq ($(ARCH),arm64)
TARGETS += neon
endif

# Default target.
all: $(TARGETS)

# Set flags and dependencies for different targets.
$(OBJ_AVX2): CFLAGS += $(AVX2_FLAG)
$(OBJ_AVX512): CFLAGS += $(AVX512_FLAG)
$(out_avx2) $(out_avx512) $(out_neon) $(out_utils): LDFLAGS += -shared
$(OUT_ALL): | $(BIN_DIR)

$(out_cli): $(OBJ_CLI) $(out_utils)
	$(CC) $(LDFLAGS) $(OBJ_CLI) $(out_utils:.dll=.lib) -o $@

$(out_avx2): $(OBJ_AVX2)
	$(CC) $(LDFLAGS) $(OBJ_AVX2) -o $@

$(out_utils): $(OBJ_UTILS)
	$(CC) $(LDFLAGS) $(OBJ_UTILS) -o $@

# Create necessary directories.
$(BIN_DIR) $(TMP_DIR_ALL):
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

# Object compilation rules.
.SECONDEXPANSION:
$(TARGETS): $$(out_$$@)

# $(TARGETS): $$(OBJ_$$@)
# 	$(CC) $(LDFLAGS) $< -o $@

$(TMP_DIR)/%.obj: $(SRC_DIR)/%.c | $$(@D)
ifdef TIDY
	$(TIDY) $< -quiet -config-file=.clang-tidy -- $(INC_DIR) $(CFLAGS)
endif
	$(CC) -c $< -o $@ $(INC_DIR) $(CFLAGS)
