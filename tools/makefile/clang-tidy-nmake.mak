# Default LLVM directory on Windows.
LLVM_DIR = "C:\Program Files\LLVM"

!IF EXIST($(LLVM_DIR))
CLANGTIDY = $(LLVM_DIR:"=)\bin\clang-tidy.exe
RUNCLANGTIDY = $(LLVM_DIR:"=)\bin\run-clang-tidy
!ENDIF

CLANGTIDY_CALL = python "$(RUNCLANGTIDY:\=\\)" -clang-tidy-binary "$(CLANGTIDY:\=\\)" -quiet -j$(NUMBER_OF_PROCESSORS)
