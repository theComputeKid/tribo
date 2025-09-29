NVCC = nvcc

CUTIDYFLAGS = --cuda-path=\"$(CUDA_PATH:\=\\)\" \
							/std:c++20 \
							/W4 \
							/WX \
							-Wpedantic \
							-Wno-unknown-cuda-version \
							-Xclang -O3
CUTIDYFLAGS = $(strip $(CUTIDYFLAGS))
