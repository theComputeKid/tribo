# GMake-compatible makefile.
include tools/makefile/setup-gmake.mak

PRJ_NAME = tribo

# Shared Library flags.
DLL_MACRO = -DTRIBO_EXPORT

BIN_DIR = bin
TMP_DIR = tmp

INC_DIR = -Isrc/include

EXE_APP = $(BIN_DIR)/$(PRJ_NAME)
DIR_APP = src/app
SRC_APP = $(wildcard $(DIR_APP)/*.c)
TMP_APP = $(TMP_DIR)/$(DIR_APP)
OBJ_APP = $(patsubst %.c,$(TMP_DIR)/%.o,$(SRC_APP))

NAME_BASE = lib$(PRJ_NAME)-base
DLL_BASE = $(BIN_DIR)/$(NAME_BASE).so
DIR_BASE = src/base
SRC_BASE = $(wildcard $(DIR_BASE)/*.c)
TMP_BASE = $(TMP_DIR)/$(DIR_BASE)
OBJ_BASE = $(patsubst %.c,$(TMP_DIR)/%.o,$(SRC_BASE))

NAME_CUDA = lib$(PRJ_NAME)-cuda
DLL_CUDA = $(BIN_DIR)/$(NAME_CUDA).so
DIR_CUDA = src/cuda
SRC_CUDA = $(wildcard $(DIR_CUDA)/*.cu)
TMP_CUDA = $(TMP_DIR)/$(DIR_CUDA)
OBJ_CUDA = $(patsubst %.cu,$(TMP_DIR)/%.o,$(SRC_CUDA))

DIR_UTILS = src/utils
SRC_UTILS = $(wildcard $(DIR_UTILS)/*.c)
TMP_UTILS = $(TMP_DIR)/$(DIR_UTILS)
OBJ_UTILS = $(patsubst %.c,$(TMP_DIR)/%.o,$(SRC_UTILS))

SRC_C = $(SRC_APP) $(SRC_BASE) $(SRC_UTILS)
SRC_TIDY = $(SRC_C)

TMP_ALL = $(TMP_APP) $(TMP_BASE) $(TMP_CUDA) $(TMP_UTILS)
OBJ_ALL = $(OBJ_APP) $(OBJ_BASE) $(OBJ_CUDA) $(OBJ_UTILS)

TARGETS_ALL = app base

ifneq ($(CUDA_SUPPORT),0)
SRC_TIDY += $(SRC_CUDA)
TARGETS_ALL += cuda
endif

# List header dependencies
DEP := $(OBJ_ALL:%.o=%.d)

# Create output directories.
MAKE_FOLDERS := $(shell mkdir -p $(BIN_DIR) $(TMP_ALL))

# Utils.
COMPILE_COMMANDS_FILE = compile_commands.json
DOCS_FOLDER = doc
HELP_FILE = tools/help.txt

all: $(TARGETS_ALL)
	@echo Built: $^

app: $(EXE_APP)
	@echo Built: $@

$(EXE_APP): $(OBJ_APP) $(OBJ_UTILS)
	$(CC) $(LDFLAGS) $^ -o $@ $(LIBS)

$(TMP_APP)/%.o: $(DIR_APP)/%.c GNUmakefile
	$(CC) -c $(INC_DIR) $(CFLAGS) $< -o $@

base: $(DLL_BASE)
	@echo Built: $@

$(DLL_BASE): $(OBJ_BASE)
	$(CC) $(LDFLAGS) -shared $^ -o $@ $(LIBS)

$(TMP_BASE)/%.o: $(DIR_BASE)/%.c GNUmakefile
	$(CC) -c $(INC_DIR) $(DLL_MACRO) $(CFLAGS) $< -o $@

cuda: $(DLL_CUDA)
	@echo Built: $@

$(DLL_CUDA): $(OBJ_CUDA)
	$(NVCC) -shared $(CULINKFLAGS) --keep-dir $(TMP_CUDA) $^ -o $@

$(TMP_CUDA)/%.o: $(DIR_CUDA)/%.cu GNUmakefile
	$(NVCC) -c $(INC_DIR) $(DLL_MACRO) $(CUFLAGS) --keep-dir $(TMP_CUDA) $< -o $@

# Utils.
$(TMP_UTILS)/%.o: $(DIR_UTILS)/%.c GNUmakefile
	$(CC) -c $(INC_DIR) $(CFLAGS) $< -o $@

clean:
	@rm -rf $(BIN_DIR) $(TMP_DIR) $(COMPILE_COMMANDS_FILE)

# Generate compile_commands.json. A dummy file is added at the end so we don't
# need to do anything fancy to remove the trailing comma.
cc:
	@echo "[" > $(COMPILE_COMMANDS_FILE)
	@for f in $(SRC_C); do echo "{ \"file\": \"$$f\", \"command\": \"$(CC) -c $(INC_DIR) $(DLL_MACRO) $(CFLAGS) $$f\", \"directory\": \"$(CURDIR)\" }," >> $(COMPILE_COMMANDS_FILE); done
ifeq ($(CUDA_SUPPORT),1)
	@for f in $(SRC_CUDA); do echo "{ \"file\": \"$$f\", \"command\": \"clang -c $(INC_DIR) $(DLL_MACRO) $(CUTIDYFLAGS) $$f\", \"directory\": \"$(CURDIR)\" }," >> $(COMPILE_COMMANDS_FILE); done
endif
	@echo "{ \"file\": \"tools/clang-tidy.c\", \"command\": \"$(CC) -w tools/clang-tidy.c\", \"directory\": \"$(CURDIR)\" }" >> $(COMPILE_COMMANDS_FILE)
	@echo "]" >> $(COMPILE_COMMANDS_FILE)

tidy:
	$(MAKE) cc CC=clang
	$(RUNCLANGTIDY) -clang-tidy-binary $(CLANGTIDY) -j$(NPROC) -quiet $(SRC_TIDY)

help:
	@cat $(HELP_FILE)

rebuild: clean
	$(MAKE) all

run: app
	LD_LIBRARY_PATH=$(BIN_DIR) \
	TRIBO_VERBOSE=$(TRIBO_VERBOSE) \
	$(EXE_APP) examples/simple.ini $(TMP_DIR)/simple.txt --bench

clang-doc:
	@$(MAKE) cc CC=clang
	@rm -rf $(DOCS_FOLDER)
	@mkdir $(DOCS_FOLDER)
	@$(CLANG_DOC) --output=$(DOCS_FOLDER) --project-name=$(PRJ_NAME) \
	$(COMPILE_COMMANDS_FILE) --executor=all-TUs $(CLANG_DOC_ARGS)

doxygen:
	@rm -rf $(DOCS_FOLDER)
	@$(MAKE) cc CC=clang
	@doxygen DoxyFile

# Add dependencies.
-include $(DEP)
