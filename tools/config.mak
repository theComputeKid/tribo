# Set flags based on build type.
ifndef CFLAGS_DEBUG
$(error Compiler flags not set)
endif

ifeq ($(DEBUG),1)
CFLAGS := $(strip $(CFLAGS_DEBUG))
CXXFLAGS := $(strip $(CXXFLAGS_DEBUG))
LDFLAGS := $(strip $(LDFLAGS_DEBUG))
LINKFLAGS := $(strip $(LINKFLAGS_DEBUG))
CUFLAGS := $(strip $(CUFLAGS_DEBUG))
CULINKFLAGS := $(strip $(CULINKFLAGS_DEBUG))
else
CFLAGS := $(strip $(CFLAGS_RELEASE))
CXXFLAGS := $(strip $(CXXFLAGS_RELEASE))
LDFLAGS := $(strip $(LDFLAGS_RELEASE))
LINKFLAGS := $(strip $(LINKFLAGS_RELEASE))
CUFLAGS := $(strip $(CUFLAGS_RELEASE))
CULINKFLAGS := $(strip $(CULINKFLAGS_RELEASE))
endif
