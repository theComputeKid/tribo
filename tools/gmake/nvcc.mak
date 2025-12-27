CU_WARNINGS = -Wno-deprecated-gpu-targets
CU_WERROR = --Werror all-warnings
CU_LD_WERROR = --Werror all-warnings

CUFLAGS_COMMON = -allow-unsupported-compiler -MD --std=c++20 --source-in-ptx -arch=native $(CU_WARNINGS) -o $@
CUFLAGS_DEBUG = -G -g -O0 $(CUFLAGS_COMMON)
CUFLAGS_RELEASE = -O3 --keep --keep-dir=$(dir $@) --generate-line-info --split-compile=0 $(CUFLAGS_COMMON)

CUARFLAGS_COMMON = $(CUFLAGS_COMMON) -allow-unsupported-compiler -dlink --threads=0 -Wno-deprecated-gpu-targets -o $@
CUARFLAGS_DEBUG = $(CUARFLAGS_COMMON)
CUARFLAGS_RELEASE = $(CUARFLAGS_COMMON) --generate-line-info

ifeq ($(OS),windows)
CUCXXFLAGS_COMMON = /W4,/WX,/external:W0,/permissive-,/FC,/Fo$@,/Fd$(basename $@).pdb
CUCXXFLAGS_DEBUG = /Zi,/Od,/MDd,/fsanitize=address,$(CUCXXFLAGS_COMMON)
CUCXXFLAGS_RELEASE = /O2,/MD,$(CUCXXFLAGS_COMMON)

CUCXXARFLAGS_COMMON = /link,/IGNORE:4001,/NOLOGO,/SUBSYSTEM:CONSOLE,/TIME,/WX,/NOIMPLIB,/MACHINE:$(ARCH)
CUCXXARFLAGS_DEBUG = /MDd,/fsanitize=address,$(CUCXXARFLAGS_COMMON)
CUCXXARFLAGS_RELEASE = /MD,$(CUCXXARFLAGS_COMMON)
else
CUFLAGS_COMMON += --compiler-bindir=$(shell which $(CXX))
CUCXXFLAGS_COMMON = -fopenmp,-Wall,-Wextra,-Wpedantic,-Werror
CUCXXFLAGS_DEBUG = -O0,-fno-omit-frame-pointer,-fsanitize=address,-fsanitize=undefined,$(CUCXXFLAGS_COMMON)
CUCXXFLAGS_RELEASE = -O3,$(CUCXXFLAGS_COMMON)

CUCXXARFLAGS_COMMON = -fopenmp
CUCXXARFLAGS_DEBUG = -fsanitize=address,-fsanitize=undefined,$(CUCXXARFLAGS_COMMON)
CUCXXARFLAGS_RELEASE = $(CUCXXARFLAGS_COMMON)
endif

CUFLAGS_DEBUG += --compiler-options="$(CUCXXFLAGS_DEBUG)"
CUFLAGS_RELEASE += --compiler-options="$(CUCXXFLAGS_RELEASE)"

CUARFLAGS_DEBUG += --compiler-options="$(CUCXXFLAGS_DEBUG)" --linker-options="$(CUCXXARFLAGS_DEBUG)"
CUARFLAGS_RELEASE += --compiler-options="$(CUCXXFLAGS_RELEASE)" --linker-options="$(CUCXXARFLAGS_RELEASE)"
