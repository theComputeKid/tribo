CUFLAGS_COMMON = -allow-unsupported-compiler -Wno-deprecated-gpu-targets --std=c++17 --source-in-ptx -arch=native
CUFLAGS_DEBUG = -G -g -O0 $(CUFLAGS_COMMON)
CUFLAGS_RELEASE = -O3 --keep --keep-dir=$(dir $@) --generate-line-info --split-compile=0 --restrict $(CUFLAGS_COMMON)

CUARFLAGS_COMMON = -allow-unsupported-compiler -Wno-deprecated-gpu-targets -dlink --threads=0 -arch=native
CUARFLAGS_DEBUG = -G -g -O0 $(CUARFLAGS_COMMON)
CUARFLAGS_RELEASE = -O3 $(CUARFLAGS_COMMON)

ifeq ($(OS),windows)
CUFLAGS_COMMON += -MD

CUHOSTFLAGS_COMMON = /W4,/WX,/external:W0,/permissive-,/FC
CUHOSTFLAGS_DEBUG = /Fd"$(basename $@).pdb",$(CUHOSTFLAGS_COMMON)
CUHOSTFLAGS_RELEASE = $(CUHOSTFLAGS_COMMON)

CUDA_DEPS += -L"$(CUDA_PATH)"/lib/x64
else
CUFLAGS_COMMON += -MMD --compiler-bindir=$(shell which $(CXX)) --objdir-as-tempdir

CUHOSTFLAGS_COMMON = -fopenmp,-Wall,-Wextra,-Wpedantic,-Werror
CUHOSTFLAGS_DEBUG = -fno-omit-frame-pointer,-fsanitize=undefined,$(CUHOSTFLAGS_COMMON)
CUHOSTFLAGS_RELEASE = $(CUHOSTFLAGS_COMMON)

CUDA_DEPS += -L/usr/local/cuda/lib64
endif

CUFLAGS_DEBUG += --compiler-options="/fsanitize=address,$(CUHOSTFLAGS_DEBUG)"
CUFLAGS_RELEASE += --compiler-options="$(CUHOSTFLAGS_RELEASE)"
CUARFLAGS_DEBUG += --compiler-options="/fsanitize=address,$(CUHOSTFLAGS_DEBUG)"
CUARFLAGS_RELEASE += --compiler-options="$(CUHOSTFLAGS_RELEASE)"

CUDA_DEPS += -lcudart_static
