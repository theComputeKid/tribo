# NMake Makefile.
.SUFFIXES:
.SUFFIXES: .c .obj

!INCLUDE tools\nmake\setup.mk
!INCLUDE tools\files.mk

INC_SRC = src\include\*.h

all: cli

!IF "$(ARCH)" == "x64"
all: avx2
!ELSEIF "$(ARCH)" == "ARM64"
all: neon
!ENDIF

# CLI Executable
cli: $(out_cli).exe

$(out_cli).exe: $(BIN_DIR) $(OBJ_CLI) utils
	$(CC) $(OBJ_CLI) $(LDFLAGS) $(IMPLIB_UTILS) /PDB:$(@R).pdb /OUT:$@

{$(SRC_DIR_CLI)}.c{$(TMP_DIR_CLI)}.obj::
	$(CC) /c $< $(INC_DIR) $(CFLAGS) /Fo"$(TMP_DIR_CLI)\\" /Fd"$(TMP_DIR_CLI)\\" /Fa"$(TMP_DIR_CLI)\\"

$(SRC_DIR_CLI)\*.c: $(INC_SRC) $(SRC_DIR_CLI)\*.h $(TMP_DIR_CLI)

# AVX2 Plugin
avx2: $(out_avx2).dll

$(out_avx2).dll: $(BIN_DIR) $(OBJ_AVX2)
	$(CC) $(OBJ_AVX2) $(LDFLAGS) /DLL /NOIMPLIB /PDB:$(@R).pdb /OUT:$@

{$(SRC_DIR_AVX2)}.c{$(TMP_DIR_AVX2)}.obj::
	$(CC) /c $< $(INC_DIR) $(CFLAGS) /arch:AVX2 /Fo"$(TMP_DIR_AVX2)\\" /Fd"$(TMP_DIR_AVX2)\\" /Fa"$(TMP_DIR_AVX2)\\"

$(SRC_DIR_AVX2)\*.c: $(INC_SRC) $(SRC_DIR_AVX2)\*.h $(TMP_DIR_AVX2)

# Utilities.
utils: $(out_utils).dll

$(out_utils).dll: $(BIN_DIR) $(OBJ_UTILS)
	$(CC) $(OBJ_UTILS) $(LDFLAGS) /DLL /IMPLIB:$(IMPLIB_UTILS) /PDB:$(@R).pdb /OUT:$@

{$(SRC_DIR_UTILS)}.c{$(TMP_DIR_UTILS)}.obj::
	$(CC) /c $< $(INC_DIR) $(CFLAGS) /Fo"$(TMP_DIR_UTILS)\\" /Fd"$(TMP_DIR_UTILS)\\" /Fa"$(TMP_DIR_UTILS)\\"

$(SRC_DIR_UTILS)\*.c: $(INC_SRC) $(TMP_DIR_UTILS)

# Create directories.
$(BIN_DIR) $(TMP_DIR_ALL):
	mkdir "$@"

clean:
	if exist "$(TMP_DIR)" rmdir /S /Q "$(TMP_DIR)"
	if exist "$(BIN_DIR)" rmdir /S /Q "$(BIN_DIR)"

rebuild: clean all

help bench test run: cli
	$(out_cli).exe --$@ --input=examples\simple.ini
