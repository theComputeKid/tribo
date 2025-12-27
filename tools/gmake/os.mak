ifeq ($(OS),Windows_NT)
	OS := windows
else ifneq ($(OS),windows)
	UNAME := $(shell uname -s | tr A-Z a-z)
	ifeq ($(UNAME),darwin)
		OS := macos
	else ifeq ($(UNAME),linux)
		OS := linux
	else
$(error Unsupported OS: $(UNAME), expected Windows, Linux or MacOS.)
	endif
endif

# OS specific settings.
ifeq ($(OS),windows)
override SHELL := cmd.exe
override SHELLFLAGS := /c
MKDIR = if not exist "$(1)" mkdir "$(1)"
RMDIR = if exist "$(1)" rmdir /s /q "$(1)"
EXE_EXT = .exe
else
MKDIR = mkdir -p "$(1)"
RMDIR = rm -rf "$(1)"
LIB_EXT = .a
EXE_EXT =
endif
