CFLAGS_COMMON = /external:anglebrackets /options:strict /Zc:preprocessor /MP /openmp
CFLAGS_DEBUG = /fsanitize=address /fsanitize-coverage=edge /MDd $(CFLAGS_COMMON)
CFLAGS_RELEASE = /O2 /Qpar /Qpar-report:1 /Qvec-report:1 /GL /MD $(CFLAGS_COMMON)
LINKFLAGS = $(LINKFLAGS) /NOEXP
