NVCC = "$(CUDA_PATH:"=)\bin\nvcc.exe"

CUTIDYFLAGS = --cuda-path=\"$(CUDA_PATH:\=\\)\" \
							/std:c++20 \
							/W4 \
							/WX \
							-Wpedantic \
							-Wno-unknown-cuda-version \
							-Xclang -O3

CUTIDYFLAGS = $(strip $(CUTIDYFLAGS))

!IF EXIST($(CUDA_PATH))
CUDA_SUPPORT = 1
!ELSE
CUDA_SUPPORT = 0
!ENDIF
