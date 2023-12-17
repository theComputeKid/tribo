# * Project CMake configuration options.
option(TRIBO_BUILD_TOOLS "Builds the latest ninja." OFF)
option(TRIBO_ENABLE_WARNINGS "Enable warnings during compilation." OFF)
option(TRIBO_USE_PCH "Use PCH during compilation." OFF)

# * Enable code checking in CodeCheck config.
option(TRIBO_CODECHECK_ENABLE_CODECOVERAGE "Enable code coverage generation in CodeCheck config." ON)
option(TRIBO_CODECHECK_ENABLE_CLANGTIDY "Enable clang-tidy in CodeCheck config." ON)
option(TRIBO_CODECHECK_ENABLE_SANITIZERS "Enable sanitizers in CodeCheck config." ON)
