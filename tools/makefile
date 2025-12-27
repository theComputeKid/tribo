# NMake Makefile.
.SUFFIXES:
.SUFFIXES: .c .obj

!INCLUDE tools\nmake\setup.mk
!INCLUDE tools\files.mk

PRJ_NAME = tribo

BIN_DIR = bin
SRC_DIR = src
TMP_DIR = tmp

INC_DIR = /Isrc\include

# Subprojects

NAME_CLI = cli
SRC_DIR_CLI = $(SRC_DIR)\$(NAME_CLI)
TMP_DIR_CLI = $(TMP_DIR)\$(NAME_CLI)
SRC_CLI = $(patsubst %,$(SRC_DIR_CLI)\\%,$(SRC_CLI))
OBJ_CLI = $(patsubst $(SRC_DIR_CLI)\\%.c,$(TMP_DIR_CLI)\\%.obj,$(SRC_CLI))
out_cli = $(BIN_DIR)\$(PRJ_NAME)-$(NAME_CLI).exe

NAME_UTILS = utils
SRC_DIR_UTILS = $(SRC_DIR)\$(NAME_UTILS)
TMP_DIR_UTILS = $(TMP_DIR)\$(NAME_UTILS)
SRC_UTILS = $(patsubst %,$(SRC_DIR_UTILS)\\%,$(SRC_UTILS))
OBJ_UTILS = $(patsubst $(SRC_DIR_UTILS)\\%.c,$(TMP_DIR_UTILS)\\%.obj,$(SRC_UTILS))
IMPLIB_UTILS = $(TMP_DIR_UTILS)\$(PRJ_NAME)-$(NAME_UTILS).lib
DLL_EXPORT_UTILS = /DTRIBO_UTILS_EXPORT
out_utils = $(BIN_DIR)\$(PRJ_NAME)-$(NAME_UTILS).dll

NAME_BASE = base
SRC_DIR_BASE = $(SRC_DIR)\$(NAME_BASE)
TMP_DIR_BASE = $(TMP_DIR)\$(NAME_BASE)
SRC_BASE = $(patsubst %,$(SRC_DIR_BASE)\\%,$(SRC_BASE))
OBJ_BASE = $(patsubst $(SRC_DIR_BASE)\\%.c,$(TMP_DIR_BASE)\\%.obj,$(SRC_BASE))
OUT_BASE = $(BIN_DIR)\$(PRJ_NAME)-$(NAME_BASE).dll

NAME_AVX = avx
SRC_DIR_AVX = $(SRC_DIR)\$(NAME_AVX)
TMP_DIR_AVX = $(TMP_DIR)\$(NAME_AVX)
SRC_AVX = $(patsubst %,$(SRC_DIR_AVX)\\%,$(SRC_AVX))
OBJ_AVX = $(patsubst $(SRC_DIR_AVX)\\%.c,$(TMP_DIR_AVX)\\%.obj,$(SRC_AVX))
OUT_AVX = $(BIN_DIR)\$(PRJ_NAME)-$(NAME_AVX).dll

NAME_NEON = neon
SRC_DIR_NEON = $(SRC_DIR)\$(NAME_NEON)
TMP_DIR_NEON = $(TMP_DIR)\$(NAME_NEON)
SRC_NEON = $(patsubst %,$(SRC_DIR_NEON)\\%,$(SRC_NEON))
OBJ_NEON = $(patsubst $(SRC_DIR_NEON)\\%.c,$(TMP_DIR_NEON)\\%.obj,$(SRC_NEON))
OUT_NEON = $(BIN_DIR)\$(PRJ_NAME)-$(NAME_NEON).dll

TMP_DIRS = $(TMP_DIR_UTILS) $(TMP_DIR_CLI) $(TMP_DIR_BASE) $(TMP_DIR_AVX) $(TMP_DIR_NEON)
DLL_EXPORT_BACKEND = /DTRIBO_EXPORT

TARGETS = cli base

!IF "$(ARCH)" == "x64"
TARGETS = $(TARGETS) avx
!ELSEIF "$(ARCH)" == "arm64"
TARGETS = $(TARGETS) neon
!ELSE
!ERROR Unknown target architecture: "$(ARCH)"
!ENDIF

all: $(TARGETS)

cli: $(out_cli)

$(out_cli): $(OBJ_CLI) $(out_utils) $(OUT_LOADER) $(BIN_DIR)
	$(CC) $(OBJ_CLI) $(LDFLAGS) $(IMPLIB_UTILS) /PDB:$(basename $@).pdb /OUT:$@

{$(SRC_DIR_CLI)}.c{$(TMP_DIR_CLI)}.obj::
	$(CC) /c $(INC_DIR) $(CFLAGS) /Fa"$(TMP_DIR_CLI)\\" /Fd"$(TMP_DIR_CLI)\\" /Fo"$(TMP_DIR_CLI)\\" $<

$(SRC_CLI): $(TMP_DIR_CLI)

utils: $(out_utils)

$(out_utils): $(OBJ_UTILS) $(BIN_DIR)
	@echo Building $@
	$(CC) $(OBJ_UTILS) $(LDFLAGS) /DLL /IMPLIB:$(IMPLIB_UTILS) /PDB:$(basename $@).pdb /OUT:$@

{$(SRC_DIR_UTILS)}.c{$(TMP_DIR_UTILS)}.obj::
	$(CC) /c $(INC_DIR) $(DLL_EXPORT_UTILS) $(CFLAGS) /Fa"$(TMP_DIR_UTILS)\\" /Fd"$(TMP_DIR_UTILS)\\" /Fo"$(TMP_DIR_UTILS)\\" $<

$(SRC_UTILS): $(TMP_DIR_UTILS)

base: $(OUT_BASE)

$(OUT_BASE): $(OBJ_BASE) $(out_utils) $(BIN_DIR)
	$(CC) $(OBJ_BASE) $(LDFLAGS) /DLL /NOIMPLIB $(IMPLIB_UTILS) /PDB:$(basename $@).pdb /OUT:$@

{$(SRC_DIR_BASE)}.c{$(TMP_DIR_BASE)}.obj::
	$(CC) /c $(INC_DIR) $(DLL_EXPORT_BACKEND) $(CFLAGS) /Fa"$(TMP_DIR_BASE)\\" /Fd"$(TMP_DIR_BASE)\\" /Fo"$(TMP_DIR_BASE)\\" $<

$(SRC_BASE): $(TMP_DIR_BASE)

avx: $(OUT_AVX)

$(OUT_AVX): $(OBJ_AVX) $(out_utils) $(BIN_DIR)
	$(CC) $(OBJ_AVX) $(LDFLAGS) /DLL /NOIMPLIB $(IMPLIB_UTILS) /PDB:$(basename $@).pdb /OUT:$@

{$(SRC_DIR_AVX)}.c{$(TMP_DIR_AVX)}.obj::
	$(CC) /c $(INC_DIR) $(DLL_EXPORT_BACKEND) $(CFLAGS) /Fa"$(TMP_DIR_AVX)\\" /Fd"$(TMP_DIR_AVX)\\" /Fo"$(TMP_DIR_AVX)\\" $<

$(SRC_AVX): $(TMP_DIR_AVX)

neon: $(OUT_NEON)

$(OUT_NEON): $(OBJ_NEON) $(out_utils) $(BIN_DIR)
	$(CC) $(OBJ_NEON) $(LDFLAGS) /DLL /NOIMPLIB $(IMPLIB_UTILS) /PDB:$(basename $@).pdb /OUT:$@

{$(SRC_DIR_NEON)}.c{$(TMP_DIR_NEON)}.obj::
	$(CC) /c $(INC_DIR) $(DLL_EXPORT_BACKEND) $(CFLAGS) /Fa"$(TMP_DIR_NEON)\\" /Fd"$(TMP_DIR_NEON)\\" /Fo"$(TMP_DIR_NEON)\\" $<

$(SRC_NEON): $(TMP_DIR_NEON)

bin $(TMP_DIRS):
	md "$@"

rebuild: clean all

run bench help version:
	$(out_cli) --$@ --verbosity=2 --input=examples\simple.ini --output=tmp\simple-out.txt --plugin=$(OUT_BASE)

tidy:
	$(TIDY) $(TIDY_FLAGS) $(SRC_CLI) -- $(CC) $(INC_DIR:/=-) $(CFLAGS)
	$(TIDY) $(TIDY_FLAGS) $(SRC_UTILS) -- $(CC) $(INC_DIR:/=-) $(DLL_EXPORT_UTILS:/=-) $(CFLAGS)
	$(TIDY) $(TIDY_FLAGS) $(SRC_BASE) -- $(CC) $(INC_DIR:/=-) $(DLL_EXPORT_BACKEND:/=-) $(CFLAGS)

!IF "$(ARCH)" == "x64"
	$(TIDY) $(TIDY_FLAGS) $(SRC_AVX) -- $(CC) $(INC_DIR:/=-) $(CFLAGS) $(AVX_FLAG)
!ELSEIF "$(ARCH)" == "arm64"
	$(TIDY) $(TIDY_FLAGS) $(SRC_NEON) -- $(CC) $(INC_DIR:/=-) $(CFLAGS)
!ENDIF

clean:
	if exist "$(BIN_DIR)" rmdir /S /Q "$(BIN_DIR)"
	if exist "$(TMP_DIR)" rmdir /S /Q "$(TMP_DIR)"
