MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(MAKEFILE_DIR)os.mak
include $(MAKEFILE_DIR)arch.mak
include $(MAKEFILE_DIR)compiler.mak

.SUFFIXES:
