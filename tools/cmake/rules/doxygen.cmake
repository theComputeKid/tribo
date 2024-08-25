# * Doxygen is used to generate API documentation, if present on the system.

if(TRIBO_ENABLE_DOC)
  find_package(Doxygen REQUIRED)
  set(DOXYGEN_GENERATE_HTML YES)
  set(DOXYGEN_GENERATE_MAN NO)
  set(DOXYGEN_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/doc/${PROJECT_NAME})
  set(DOXYGEN_WARN_AS_ERROR YES)
  set(DOXYGEN_QUIET YES)
  set(DOXYGEN_EXCLUDE_PATTERNS *.c*)
  doxygen_add_docs(doc
    backend
    ${TRIBO_EXPORT_HEADER_DIR}
    ALL
  )
  install(DIRECTORY "${CMAKE_BINARY_DIR}/doc/${PROJECT_NAME}" TYPE DOC)
endif()
