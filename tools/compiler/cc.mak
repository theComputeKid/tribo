MAKEFILE_DIR = $(dir $(lastword $(MAKEFILE_LIST)))

ifeq ($(OS),Darwin)
include $(MAKEFILE_DIR)/clang.mak
else ifeq ($(OS),Linux)
include $(MAKEFILE_DIR)/gcc.mak
else ifeq ($(OS),Windows_NT)
include $(MAKEFILE_DIR)/cl.mak
endif
