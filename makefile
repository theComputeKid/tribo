# Windows NMake-compatible makefile.

.SUFFIXES:
.SUFFIXES: .c .cu

!INCLUDE tools\makefile\setup-nmake.mak

PRJ_NAME = tribo

# Shared Library flags.
DLL_MACRO = /DTRIBO_EXPORT

BIN_DIR = bin
TMP_DIR = tmp

INC_DIR = /Isrc\include

EXE_APP = $(BIN_DIR)\$(PRJ_NAME).exe
SRC_APP = main.c
DIR_APP = src\app
TMP_APP = $(TMP_DIR)\$(DIR_APP)
OBJ_APP = $(patsubst %.c,$(TMP_APP)\\%.obj,$(SRC_APP))
SRC_FULL_APP = $(patsubst %,$(DIR_APP)\\%,$(SRC_APP))
OUT_DIR_APP = /Fa$(TMP_APP)\ /Fo$(TMP_APP)\ /Fd$(TMP_APP)\\

NAME_BASE = lib$(PRJ_NAME)-base
DLL_BASE = $(BIN_DIR)\$(NAME_BASE).dll
SRC_BASE = main.c
DIR_BASE = src\base
TMP_BASE = $(TMP_DIR)\$(DIR_BASE)
OBJ_BASE = $(patsubst %.c,$(TMP_BASE)\\%.obj,$(SRC_BASE))
SRC_FULL_BASE = $(patsubst %,$(DIR_BASE)\\%,$(SRC_BASE))
OUT_DIR_BASE = /Fa$(TMP_BASE)\ /Fo$(TMP_BASE)\ /Fd$(TMP_BASE)\\

NAME_CUDA = lib$(PRJ_NAME)-cuda
DLL_CUDA = $(BIN_DIR)\$(NAME_CUDA).dll
SRC_CUDA = main.cu
DIR_CUDA = src\cuda
TMP_CUDA = $(TMP_DIR)\$(DIR_CUDA)
OBJ_CUDA = $(patsubst %.cu,$(TMP_CUDA)\\%.obj,$(SRC_CUDA))
SRC_FULL_CUDA = $(patsubst %,$(DIR_CUDA)\\%,$(SRC_CUDA))
OUT_DIR_CUDA = -odir $(TMP_CUDA) --keep-dir $(TMP_CUDA) -Xcompiler "/Fa$(TMP_CUDA)\\ /Fd$(TMP_CUDA)\\"
DEPS_CUDA = $(patsubst %.obj,%.d,$(OBJ_CUDA))
DEP_FILE_CUDA = $(TMP_CUDA)\deps.mak

# Determine which targets to build for "all" and tidy.
SRC_TIDY = $(SRC_FULL_APP) $(SRC_FULL_BASE)
TARGETS_ALL = app base

!IF EXIST($(CUDA_PATH))
# Disable clang-tidy for cuda on Windows, as it doesn't handle .cu files well.
# SRC_TIDY = $(SRC_TIDY) $(SRC_FULL_CUDA)
TARGETS_ALL = $(TARGETS_ALL) cuda
!ENDIF

# Utils.
COMPILE_COMMANDS_FILE = compile_commands.json
HELP_FILE = tools\help.txt
DEPS_DIR = $(TMP_DIR)\deps
DEPS_FILE = $(DEPS_DIR)\deps.mak

all: $(TARGETS_ALL)
	@echo Built: $**

app: $(EXE_APP)
	@echo Built: $@

$(EXE_APP): $(OBJ_APP)
	@if not exist $(BIN_DIR) mkdir $(BIN_DIR)
	$(CC) $(LDFLAGS) $** /link $(LINKFLAGS) /PDB:$(TMP_APP)\symbols.pdb /OUT:$@

{$(DIR_APP)}.c{$(TMP_APP)}.obj::
	@if not exist $(TMP_APP) mkdir $(TMP_APP)
	$(CC) /c $(INC_DIR) $(DLL_MACRO) $(CFLAGS) $(OUT_DIR_APP) $<

base: $(DLL_BASE)
	@echo Built: $@

$(DLL_BASE): $(OBJ_BASE)
	@if not exist $(BIN_DIR) mkdir $(BIN_DIR)
	$(CC) $(LDFLAGS) $** /link $(LINKFLAGS) /DLL /PDB:$(TMP_BASE)\symbols.pdb /OUT:$@

{$(DIR_BASE)}.c{$(TMP_BASE)}.obj::
	@if not exist $(TMP_BASE) mkdir $(TMP_BASE)
	$(CC) /c $(INC_DIR) $(DLL_MACRO) $(CFLAGS) $(OUT_DIR_BASE) $<

cuda: $(DLL_CUDA)
	@echo Built: $@

$(DLL_CUDA): $(OBJ_CUDA)
	@if not exist $(BIN_DIR) mkdir $(BIN_DIR)
	$(NVCC) --shared $(CULINKFLAGS) --keep-dir $(TMP_CUDA) $** -o $@

{$(DIR_CUDA)}.cu{$(TMP_CUDA)}.obj::
	@if not exist $(TMP_CUDA) mkdir $(TMP_CUDA)
	$(NVCC) -dc $(INC_DIR:/=-) $(DLL_MACRO:/=-) $(CUFLAGS) $(OUT_DIR_CUDA) $<
	@echo Creating dependency file from nvcc -MD output...
#	Combine all dep files.
	@type $(DEPS_CUDA) > $(DEP_FILE_CUDA).1.tmp
# Remove all lines containing a space. Those can't be part of this project.
	@findstr /V /C:"\\ " $(DEP_FILE_CUDA).1.tmp > $(DEP_FILE_CUDA).2.tmp
# Convert paths to Windows format and make them relative to the makefile directory.
	@powershell -NoProfile -ExecutionPolicy Bypass -Command \
	"(Get-Content '$(DEP_FILE_CUDA).2.tmp') \
	-replace('/','\') -replace('$(MAKEDIR:\=\\)\\','') \
	| Set-Content '$(DEP_FILE_CUDA)'"

clean:
	@if exist $(BIN_DIR) rmdir /s /q $(BIN_DIR)
	@if exist $(TMP_DIR) rmdir /s /q $(TMP_DIR)
	@if exist $(COMPILE_COMMANDS_FILE) del $(COMPILE_COMMANDS_FILE)

rebuild: clean
	@$(MAKE) /nologo all

# Generate compile_commands.json. A dummy file is added at the end so we don't
# need to do anything fancy to remove the trailing comma.
cc:
	@echo [ > $(COMPILE_COMMANDS_FILE)
	@for %f in ($(SRC_APP)) do @echo { "file": "$(DIR_APP:\=\\)\\%f", "command": "$(CC:\=\\) $(INC_DIR:\=\\) $(CFLAGS) $(DIR_APP:\=\\)\\%f", "directory": "$(MAKEDIR:\=\\)" }, >> $(COMPILE_COMMANDS_FILE)
	@for %f in ($(SRC_BASE)) do @echo { "file": "$(DIR_BASE:\=\\)\\%f", "command": "$(CC:\=\\) $(INC_DIR:\=\\) $(CFLAGS) $(DIR_BASE:\=\\)\\%f", "directory": "$(MAKEDIR:\=\\)" }, >> $(COMPILE_COMMANDS_FILE)
	@for %f in ($(SRC_CUDA)) do @echo { "file": "$(DIR_CUDA:\=\\)\\%f", "command": "$(CC:\=\\) $(INC_DIR:\=\\) $(CUTIDYFLAGS) $(DIR_CUDA:\=\\)\\%f", "directory": "$(MAKEDIR:\=\\)" }, >> $(COMPILE_COMMANDS_FILE)
	@echo { "file": "tools\\clang-tidy.c", "command": "$(CC:\=\\) /W0 tools\\clang-tidy.c", "directory": "$(MAKEDIR:\=\\)" } >> $(COMPILE_COMMANDS_FILE)
	@echo ] >> $(COMPILE_COMMANDS_FILE)

tidy:
	@$(MAKE) /nologo cc CC=clang-cl
	$(CLANGTIDY_CALL) $(SRC_TIDY:\=\\)

deps:
	@if exist $(DEPS_DIR) rmdir /s /q $(DEPS_DIR)
	@mkdir $(DEPS_DIR)
	@if exist $(DEPS_FILE).mak del $(DEPS_FILE).mak
	cl $(CLDEPSFLAGS) $(INC_DIR) $(SRC_FULL_APP) > $(DEPS_DIR)\app.txt
	cl $(CLDEPSFLAGS) $(INC_DIR) $(SRC_FULL_BASE) > $(DEPS_DIR)\base.txt
	@powershell -ExecutionPolicy Bypass -Command ". 'tools\Write-NMakeDependencies.ps1'; \
	Write-NMakeDependencies -InputFile '$(DEPS_DIR)\app.txt' -OutputFile '$(DEPS_FILE)' -SourceDir '$(DIR_APP)' -TempDir '$(TMP_APP)'; \
	Write-NMakeDependencies -InputFile '$(DEPS_DIR)\base.txt' -OutputFile '$(DEPS_FILE)' -SourceDir '$(DIR_BASE)' -TempDir '$(TMP_BASE)'"

help:
	@type $(HELP_FILE)

run: app
	$(EXE_APP) examples\simple.ini $(TMP_DIR)\simple.txt --bench

# Add dependencies.
!IF EXIST($(DEPS_FILE))
!INCLUDE $(DEPS_FILE)
!ENDIF

!IF EXIST($(DEP_FILE_CUDA))
!INCLUDE $(DEP_FILE_CUDA)
!ENDIF
