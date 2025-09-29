ifeq ($(OS),macos)
LLVM_DIR ?= $(shell brew --prefix llvm)
CLANGTIDY ?= $(LLVM_DIR)/bin/clang-tidy
RUNCLANGTIDY ?= $(LLVM_DIR)/bin/run-clang-tidy
else ifeq ($(OS),linux)
CLANGTIDY ?= clang-tidy
RUNCLANGTIDY ?= run-clang-tidy
endif
