ARCH = $(VSCMD_ARG_TGT_ARCH)

!IF "$(CC)" == "clang-cl"
!INCLUDE clang-cl.mk
!ELSEIF "$(CC)" == "icx-cl"
!INCLUDE icx-cl.mk
!ELSEIF "$(CC)" == "cl"
!INCLUDE cl.mk
!ELSE
!ERROR Unsupported compiler: $(CC), expected cl, clang-cl or icx-cl
!ENDIF

!INCLUDE link.mk
!INCLUDE tidy.mk

!IF "$(DEBUG)" != "0"
CFLAGS = $(CFLAGS_DEBUG)
LDFLAGS = $(LDFLAGS_DEBUG) /link $(LINKFLAGS_DEBUG)
!ELSE
CFLAGS = $(CFLAGS_RELEASE)
LDFLAGS = $(LDFLAGS_RELEASE) /link $(LINKFLAGS_RELEASE)
!ENDIF

CFLAGS = /c /std:c11 /nologo /W4 /external:W0 /permissive- /diagnostics:caret /FC /Zc:__STDC__ $(CFLAGS) /Fa"$(@R)\\" /Fd"$(@R)\\" /Fo"$(@R)\\"
LDFLAGS = /nologo $(LDFLAGS)
ARFLAGS = /nologo


AVX_FLAG = /arch:AVX


!IF "$(WERROR)" != "0"
CFLAGS = $(CFLAGS) /WX
LDFLAGS = $(LDFLAGS) /WX
!ENDIF

LDFLAGS = $(strip $(LDFLAGS))
