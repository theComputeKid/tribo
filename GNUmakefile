# Main project makefile. For use with GNU Make on Linux, MacOS and Windows.

include $(realpath tools/gmake/setup.mak)

BIN_DIR = bin
TMP_DIR = tmp
OUT = $(BIN_DIR)/tribo$(EXE_EXT)

INC_DIR = -Isrc/include

# Source files.
SRC_APP = $(wildcard src/app/*.c)
SRC_BASE = $(wildcard src/base/*.c)
SRC_UTILS = $(wildcard src/utils/*.c)
SRC_AVX = $(wildcard src/avx/*.c)
SRC_NEON = $(wildcard src/neon/*.c)

# Output objects.
OBJ_APP = $(patsubst src/%.c,tmp/%.o,$(SRC_APP))
OBJ_BASE = $(patsubst src/%.c,tmp/%.o,$(SRC_BASE))
OBJ_UTILS = $(patsubst src/%.c,tmp/%.o,$(SRC_UTILS))
OBJ_AVX = $(patsubst src/%.c,tmp/%.o,$(SRC_AVX))
OBJ_NEON = $(patsubst src/%.c,tmp/%.o,$(SRC_NEON))

# All libraries to actually build.
LIBS := app base utils
OBJ := $(OBJ_APP) $(OBJ_BASE) $(OBJ_UTILS)

ifeq ($(ARCH),x64)
LIBS += avx
OBJ += $(OBJ_AVX)
$(OBJ_AVX): CFLAGS += $(AVX_FLAG)
else ifeq ($(ARCH),arm64)
LIBS += neon
OBJ += $(OBJ_NEON)
endif

TMP_DIRS := $(patsubst %,$(TMP_DIR)/%/,$(LIBS))
LIBS := $(patsubst %,$(TMP_DIR)/%.a,$(LIBS))
DEPS := $(OBJ:.o=.d)

# Link all libraries into final executable.
$(OUT): $(LIBS) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ -o $@

# Create necessary directories.
$(BIN_DIR) $(TMP_DIRS):
	$(call MKDIR,$@)

clean:
	$(call RMDIR,$(BIN_DIR))
	$(call RMDIR,$(TMP_DIR))

rebuild: clean
	@$(MAKE) --no-print-directory $(OUT)

run help version:
	$(OUT) --$@ --input=examples/simple.ini --output=$(TMP_DIR)/output.txt --verbosity=2

-include $(DEPS)

.SECONDEXPANSION:
$(LIBS): $$(patsubst src/%.c,tmp/%.o,$$(wildcard src/$$(basename $$(@F))/*.c))
	$(AR) $(ARFLAGS) $@ $^

$(OBJ): $$(patsubst tmp/%.o,src/%.c,$$(@)) | $$(dir $$(@))
	$(CC) -c $< -o $@ $(INC_DIR) $(CFLAGS)
