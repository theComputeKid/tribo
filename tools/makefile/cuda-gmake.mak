# Determine if CUDA is supported and set the CUDA path accordingly.

CUDA_SUPPORT = 1 # Assume CUDA is supported by default.

# Default CUDA paths in most linux systems.
CUDA_PATH ?= /usr/local/cuda
CUDA_PATH_V12 ?= /usr/local/cuda-12

# For clang-tidy.
ifneq ($(wildcard $(CUDA_PATH_V12)),)
TIDY_CUDA_PATH ?= $(CUDA_PATH_V12)
else ifneq ($(wildcard $(CUDA_PATH)),)
TIDY_CUDA_PATH ?= $(CUDA_PATH)
else
CUDA_SUPPORT = 0
endif

NVCC ?= $(CUDA_PATH)/bin/nvcc

CUTIDYFLAGS = --cuda-path=$(CUDA_PATH) \
							-std=c++20 \
							-Wall \
							-Wextra \
							-Werror \
							-Wpedantic \
							-Wno-unknown-cuda-version \
							-O3 \
							--no-cuda-version-check
