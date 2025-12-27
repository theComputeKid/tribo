CFLAGS_COMMON = /external:anglebrackets /options:strict /Zc:preprocessor /MP /openmp
CFLAGS_DEBUG = /Od /Zi /MDd /fsanitize=address /fsanitize-coverage=edge $(CFLAGS_COMMON)
CFLAGS_RELEASE = /O2 /FAs /MD /Qpar /Qpar-report:1 /Qvec-report:1 /GL $(CFLAGS_COMMON)

AR = lib

RUNTIME_LIB_DEBUG = msvcrtd.lib
RUNTIME_LIB_RELEASE = msvcrt.lib
