# Compiler identification.

# Deal with spaces in compiler path. Each space creates a new word.
COMPILER_ID_NUM_WORDS := $(words $(CC))
COMPILER_ID := $(word $(COMPILER_ID_NUM_WORDS),$(CC)) # Get last word
COMPILER_ID := $(basename $(COMPILER_ID)) # Remove extension
COMPILER_ID := $(notdir $(COMPILER_ID)) # Remove directory

ifneq ($(findstring clang-cl,$(COMPILER_ID)),)
COMPILER_ID := clang-cl
else ifneq ($(findstring gcc,$(COMPILER_ID)),)
COMPILER_ID := gcc
else ifneq ($(findstring clang,$(COMPILER_ID)),)
COMPILER_ID := clang
else ifneq ($(findstring icx-cl,$(COMPILER_ID)),)
COMPILER_ID := icx-cl
else ifneq ($(findstring icx,$(COMPILER_ID)),)
COMPILER_ID := icx
else ifneq ($(findstring cl,$(COMPILER_ID)),)
COMPILER_ID := cl
else ifneq ($(findstring cc,$(COMPILER_ID)),)
COMPILER_ID := cc
else
$(error Unknown compiler: $(COMPILER_ID))
endif

# Add quotes if there were spaces
ifneq ($(strip $(COMPILER_ID_NUM_WORDS)),1)
CC := "$(CC)"
endif

COMPILER_ID :=$(strip $(COMPILER_ID))
