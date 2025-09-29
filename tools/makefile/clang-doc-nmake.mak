# clang-doc settings.
!IFDEF LLVM_DIR
CLANG_DOC = $(LLVM_DIR)\bin\clang-doc.exe
!ELSE
CLANG_DOC = clang-doc
!ENDIF

CLANG_DOC_ARGS =	--format=md \
									--extra-arg=-Wno-unknown-argument \
									--ignore-map-errors \
									--public

CLANG_DOC_ARGS = $(strip $(CLANG_DOC_ARGS))
