# GMake-compatible makefile.

include tools/detect-arch-gmake.mak
include tools/compilers/setup-gmake.mak

PRJ_NAME = tribo
PRJ_SUFFIX = $(OS)-$(ARCH)

# Shared Library flags.
DLL_MACRO = -DTRIBO_EXPORT

BIN_DIR = bin
TMP_DIR = tmp

INC_DIR = -Isrc/include

EXE_APP = $(BIN_DIR)/$(PRJ_NAME)-$(PRJ_SUFFIX)
DIR_APP = src/app
SRC_APP = $(wildcard $(DIR_APP)/*.c)
TMP_APP = $(TMP_DIR)/$(DIR_APP)
OBJ_APP = $(patsubst %.c,$(TMP_DIR)/%.o,$(SRC_APP))

NAME_BASE = lib$(PRJ_NAME)-base-$(PRJ_SUFFIX)
DLL_BASE = $(BIN_DIR)/$(NAME_BASE).so
DIR_BASE = src/base
SRC_BASE = $(wildcard $(DIR_BASE)/*.c)
TMP_BASE = $(TMP_DIR)/$(DIR_BASE)
OBJ_BASE = $(patsubst %.c,$(TMP_DIR)/%.o,$(SRC_BASE))

SRC_ALL = $(SRC_APP) $(SRC_BASE)
TMP_ALL = $(TMP_APP) $(TMP_BASE)
OBJ_ALL = $(OBJ_APP) $(OBJ_BASE)

# List header dependencies
DEP := $(OBJ_ALL:%.o=%.d)

# Create output directories.
MAKE_FOLDERS := $(shell mkdir -p $(BIN_DIR) $(TMP_ALL))

# Utils.
COMPILE_COMMANDS_FILE = compile_commands.json
HELP_FILE = tools/help.txt

all: app base
	@echo Built: $^

app: $(EXE_APP)
	@echo Built: $@

$(EXE_APP): $(OBJ_APP)
	$(CC) $(LDFLAGS) $^ -o $@ $(LIBS)

$(TMP_APP)/%.o: $(DIR_APP)/%.c GNUmakefile
	$(CC) -c $(INC_DIR) $(CFLAGS) $< -o $@

base: $(DLL_BASE)
	@echo Built: $@

$(DLL_BASE): $(OBJ_BASE)
	$(CC) $(LDFLAGS) -shared $^ -o $@ $(LIBS)

$(TMP_BASE)/%.o: $(DIR_BASE)/%.c GNUmakefile
	$(CC) -c $(INC_DIR) $(DLL_MACRO) $(CFLAGS) $< -o $@

clean:
	@rm -rf $(BIN_DIR) $(TMP_DIR) $(COMPILE_COMMANDS_FILE)

# Generate compile_commands.json. A dummy file is added at the end so we don't
# need to do anything fancy to remove the trailing comma.
cc:
	@echo "[" > $(COMPILE_COMMANDS_FILE)
	@for f in $(SRC_APP); do echo "{ \"file\": \"$$f\", \"command\": \"$(CC) $(INC_DIR) $(CTIDYFLAGS) -c $$f\", \"directory\": \"$(CURDIR)\" }," >> $(COMPILE_COMMANDS_FILE); done
	@for f in $(SRC_BASE); do echo "{ \"file\": \"$$f\", \"command\": \"$(CC) $(INC_DIR) $(DLL_MACRO) $(CTIDYFLAGS) -c $$f\", \"directory\": \"$(CURDIR)\" }," >> $(COMPILE_COMMANDS_FILE); done
	@echo "{ \"file\": \"tools/clang-tidy.c\", \"command\": \"$(CC) -w tools/clang-tidy.c\", \"directory\": \"$(CURDIR)\" }" >> $(COMPILE_COMMANDS_FILE)
	@echo "]" >> $(COMPILE_COMMANDS_FILE)

tidy: cc
	$(RUNCLANGTIDY) -clang-tidy-binary $(CLANGTIDY) -j$(NPROC) -quiet $(SRC_APP) $(SRC_BASE)

help:
	@cat $(HELP_FILE)

rebuild: clean
	$(MAKE) all

run: app
	LD_LIBRARY_PATH=$(BIN_DIR) $(EXE_APP) examples/simple.ini $(TMP_DIR)/simple.txt --bench

# Add dependencies.
-include $(DEP)
