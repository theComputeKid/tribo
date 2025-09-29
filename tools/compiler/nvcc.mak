ifeq ($(OS),Windows_NT)
NVCC ?= nvcc
else ifeq ($(OS),Linux)
NVCC ?= /usr/local/cuda/bin/nvcc
else ifeq ($(OS),Darwin)
NVCC ?= /usr/local/cuda/bin/nvcc
endif

CUFLAGS_COMMON :=  \
									--std=c++20 \
									--threads=0 \
									--Werror all-warnings \
									--source-in-ptx \
									-arch=all-major \
									-Wno-deprecated-gpu-targets

ifeq ($(OS),Windows_NT)
CUFLAGS_COMMON += -MD
else
CUFLAGS_COMMON += -MMD
endif

CUFLAGS_DEBUG := $(CUFLAGS_COMMON) -G -g -O0
CUFLAGS_RELEASE := $(CUFLAGS_COMMON) \
									-O3 \
									-dlto \
									--keep \
									--generate-line-info \
									--split-compile=0

CULINKFLAGS_COMMON := -dlink --threads=0 -Wno-deprecated-gpu-targets
CULINKFLAGS_DEBUG := $(CULINKFLAGS_COMMON)
CULINKFLAGS_RELEASE := $(CULINKFLAGS_COMMON) -dlto --generate-line-info

# Output paths for compilation
define output-paths-compile-nvcc
-o $(1) -MF $(1).d
endef

define output-paths-link-nvcc
-o $(1)
endef
