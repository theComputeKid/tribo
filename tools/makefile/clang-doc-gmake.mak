# clang-doc settings.
ifneq ($(wildcard $(LLVM_DIR)),)
CLANG_DOC ?= $(LLVM_DIR)/bin/clang-doc
else
CLANG_DOC ?= clang-doc
endif

CLANG_DOC_ARGS ?=	--format=md \
									--extra-arg=-Wno-unknown-argument \
									--ignore-map-errors \
									--public

CLANG_DOC_ARGS ?= $(strip $(CLANG_DOC_ARGS))
