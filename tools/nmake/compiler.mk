!IF "$(CC)" == "clang-cl"
COMPILER_FAMILY = clang-cl
!ELSEIF "$(CC)" == "icx-cl"
COMPILER_FAMILY = icx-cl
!ELSEIF "$(CC)" == "cl"
COMPILER_FAMILY = cl
!ELSE
!ERROR Unsupported compiler: $(CC), expected cl, clang-cl or icx-cl
!ENDIF

!INCLUDE $(COMPILER_FAMILY).mk
