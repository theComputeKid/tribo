INC_DIR = -Isrc/include

BASE_SRC_CLI = cmd.c info.c main.c
BASE_SRC_UTILS = isa.c parse.c plugin.c time.c
BASE_SRC_BASE = allocate.c init.c main.c
BASE_SRC_AVX2 = main.c
BASE_SRC_NEON = main.c

PRJ_NAME = tribo

BIN_DIR = bin
SRC_DIR = src
TMP_DIR = tmp

SRC_DIR_CLI = $(SRC_DIR)/cli
SRC_DIR_UTILS = $(SRC_DIR)/utils
SRC_DIR_BASE = $(SRC_DIR)/base
SRC_DIR_AVX2 = $(SRC_DIR)/avx2
SRC_DIR_NEON = $(SRC_DIR)/neon

SRC_CLI = $(patsubst %,$(SRC_DIR_CLI)/%,$(BASE_SRC_CLI))
SRC_UTILS = $(patsubst %,$(SRC_DIR_UTILS)/%,$(BASE_SRC_UTILS))
SRC_BASE = $(patsubst %,$(SRC_DIR_BASE)/%,$(BASE_SRC_BASE))
SRC_AVX2 = $(patsubst %,$(SRC_DIR_AVX2)/%,$(BASE_SRC_AVX2))
SRC_NEON = $(patsubst %,$(SRC_DIR_NEON)/%,$(BASE_SRC_NEON))

OBJ_CLI = $(patsubst $(SRC_DIR)/%.c,$(TMP_DIR)/%.obj,$(SRC_CLI))
OBJ_UTILS = $(patsubst $(SRC_DIR)/%.c,$(TMP_DIR)/%.obj,$(SRC_UTILS))
OBJ_BASE = $(patsubst $(SRC_DIR)/%.c,$(TMP_DIR)/%.obj,$(SRC_BASE))
OBJ_AVX2 = $(patsubst $(SRC_DIR)/%.c,$(TMP_DIR)/%.obj,$(SRC_AVX2))
OBJ_NEON = $(patsubst $(SRC_DIR)/%.c,$(TMP_DIR)/%.obj,$(SRC_NEON))
OBJ_ALL = $(OBJ_CLI) $(OBJ_UTILS) $(OBJ_BASE) $(OBJ_AVX2) $(OBJ_NEON)

DEPS = $(OBJ_ALL:.obj=.d)

TMP_DIR_CLI = $(patsubst $(SRC_DIR)/%,$(TMP_DIR)/%,$(SRC_DIR_CLI))
TMP_DIR_UTILS = $(patsubst $(SRC_DIR)/%,$(TMP_DIR)/%,$(SRC_DIR_UTILS))
TMP_DIR_BASE = $(patsubst $(SRC_DIR)/%,$(TMP_DIR)/%,$(SRC_DIR_BASE))
TMP_DIR_AVX2 = $(patsubst $(SRC_DIR)/%,$(TMP_DIR)/%,$(SRC_DIR_AVX2))
TMP_DIR_NEON = $(patsubst $(SRC_DIR)/%,$(TMP_DIR)/%,$(SRC_DIR_NEON))
TMP_DIR_ALL = $(TMP_DIR_CLI) $(TMP_DIR_UTILS) $(TMP_DIR_BASE) $(TMP_DIR_AVX2) $(TMP_DIR_NEON)

out_cli = $(BIN_DIR)/$(PRJ_NAME)-cli.exe
OUT_BASE = $(BIN_DIR)/$(PRJ_NAME)-base.dll
out_utils = $(BIN_DIR)/$(PRJ_NAME)-utils.dll
out_avx2 = $(BIN_DIR)/$(PRJ_NAME)-avx2.dll
OUT_NEON = $(BIN_DIR)/$(PRJ_NAME)-neon.dll
OUT_ALL = $(out_cli) $(OUT_BASE) $(out_utils) $(out_avx2) $(OUT_NEON)

IMPLIB_UTILS = $(TMP_DIR_UTILS)/utils.lib
