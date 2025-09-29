CUFLAGS_COMMON = 	-MD \
									--std=c++20 \
									--threads=0 \
									--Werror all-warnings \
									--source-in-ptx \
									-arch=all-major \
									-Wno-deprecated-gpu-targets

CUFLAGS_DEBUG = $(CUFLAGS_COMMON) -G -g -O0
CUFLAGS_RELEASE = $(CUFLAGS_COMMON) \
									-O3 \
									-dlto \
									--keep \
									--generate-line-info \
									--split-compile=0

CULINKFLAGS_COMMON = -dlink --threads=0 -Wno-deprecated-gpu-targets
CULINKFLAGS_DEBUG = $(CULINKFLAGS_COMMON)
CULINKFLAGS_RELEASE = $(CULINKFLAGS_COMMON) -dlto --generate-line-info
