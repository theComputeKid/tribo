# NMake Makefile.
.SUFFIXES:

!INCLUDE tools\nmake\setup.mk

OUT = bin\tribo.exe

LIBS = app base utils

!IF "$(ARCH)" == "x64"
LIBS = $(LIBS) avx
!ELSEIF "$(ARCH)" == "arm64"
LIBS = $(LIBS) neon
!ELSE
!ERROR Unknown target architecture: "$(ARCH)"
!ENDIF

LIBS = $(patsubst %,tmp\\%.lib,$(LIBS))

$(OUT): $(LIBS)
	if not exist "$(@D)" mkdir "$(@D)"
	$(CC) $(LIBS) $(LDFLAGS) /PDB:$(@D)\symbols.pdb /OUT:$@

src\app\*.c: src\app\app.h

tmp\app.lib: src\app\*.c
	if not exist "$(@R)" mkdir "$(@R)"
	$(CC) $(CFLAGS) $?
	$(AR) $(ARFLAGS) $(patsubst src\\%.c,tmp\\%.obj,$**) /OUT:$@

src\base\*.c: src\base\base.h

tmp\base.lib: src\base\*.c
	if not exist "$(@R)" mkdir "$(@R)"
	$(CC) $(CFLAGS) $?
	$(AR) $(ARFLAGS) $(patsubst src\\%.c,tmp\\%.obj,$**) /OUT:$@

src\avx\*.c: src\avx\avx.h

tmp\avx.lib: src\avx\*.c
	if not exist "$(@R)" mkdir "$(@R)"
	$(CC) $(CFLAGS) $(AVX_FLAG) $?
	$(AR) $(ARFLAGS) $(patsubst src\\%.c,tmp\\%.obj,$**) /OUT:$@

src\neon\*.c: src\neon\neon.h

tmp\neon.lib: src\neon\*.c
	if not exist "$(@R)" mkdir "$(@R)"
	$(CC) $(CFLAGS) $?
	$(AR) $(ARFLAGS) $(patsubst src\\%.c,tmp\\%.obj,$**) /OUT:$@

src\utils\*.c: src\utils\utils.h

tmp\utils.lib: src\utils\*.c
	if not exist "$(@R)" mkdir "$(@R)"
	$(CC) $(CFLAGS) $?
	$(AR) $(ARFLAGS) $(patsubst src\\%.c,tmp\\%.obj,$**) /OUT:$@

clean:
	if exist bin rmdir /S /Q bin
	if exist tmp rmdir /S /Q tmp

rebuild: clean $(OUT)

run bench:
	$(OUT) --verbosity=2 --mode=$@ --input=examples\simple.ini --output=tmp\simple-out.txt

tidy:
	$(TIDY) $(TIDY_FLAGS) src\app\*.c src\base\*.c -- $(CC) $(CFLAGS)
!IF "$(ARCH)" == "x64"
	$(TIDY) $(TIDY_FLAGS) src\avx\*.c -- $(CC) $(CFLAGS) $(AVX_FLAG)
!ELSEIF "$(ARCH)" == "arm64"
	$(TIDY) $(TIDY_FLAGS) src\neon\*.c -- $(CC) $(CFLAGS)
!ENDIF
