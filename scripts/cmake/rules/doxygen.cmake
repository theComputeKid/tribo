# * Doxygen is used to generate API documentation, if present on the system.
include(FindDoxygen)

if(DOXYGEN_FOUND)
  set(DOXYGEN_GENERATE_HTML YES)
  set(DOXYGEN_GENERATE_MAN NO)
  set(DOXYGEN_OUTPUT_DIRECTORY ${TRIBO_ROOT_DIR}/doc/build)
  set(DOXYGEN_WARN_AS_ERROR YES)
  set(DOXYGEN_QUIET YES)
  doxygen_add_docs(doc
    components
    ALL
  )
endif(DOXYGEN_FOUND)
