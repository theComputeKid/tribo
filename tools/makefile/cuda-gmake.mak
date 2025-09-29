CUDA_PATH_V12 = /usr/local/cuda-12

# For clang-tidy.
ifneq ($(wildcard $(CUDA_PATH_V12)),)
CUDA_PATH ?= $(CUDA_PATH_V12)
else
CUDA_PATH ?= /usr/local/cuda
endif

NVCC ?= /usr/local/cuda/bin/nvcc

CUTIDYFLAGS = --cuda-path=$(CUDA_PATH) \
							-std=c++20 \
							-Wall \
							-Wextra \
							-Werror \
							-Wpedantic \
							-Wno-unknown-cuda-version \
							-O3 \
							--no-cuda-version-check
