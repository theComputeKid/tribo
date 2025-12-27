ifndef CXX_COMPILER_FAMILY
$(error CXX_COMPILER_FAMILY is not defined.)
else ifndef OS
$(error OS is not defined.)
endif

TIDY_CXXFLAGS = -std=c++23 -Wall -Wextra -Wpedantic -Werror
TIDY_CONFIG = -quiet

PYTHON = python

ifeq ($(OS)-$(CXX_COMPILER_FAMILY),windows-clang)
CLANG_DIRECTORY = $(shell pwsh -NoProfile -Command "[System.IO.Path]::GetDirectoryName((Get-Command "$(CXX)").Source)")
RUN_TIDY = $(PYTHON) "$(CLANG_DIRECTORY)\run-clang-tidy"
else ifeq ($(OS),windows)
CLANG_DIRECTORY = $(shell pwsh -NoProfile -Command "[System.IO.Path]::GetDirectoryName((Get-Command clang).Source)")
RUN_TIDY = $(PYTHON) "$(CLANG_DIRECTORY)\run-clang-tidy"
else
RUN_TIDY = run-clang-tidy
endif
