#define TRIBO_UTILS_EXPORT
#include "triboUtils.h"
#include <stddef.h>
#include <stdio.h>

#if defined(__linux__)
#  include <dlfcn.h>
static char const TRIBO_PLUGIN_BASE[] = "libtribo-base.so";
static char const TRIBO_PLUGIN_AVX2[] = "libtribo-avx2.so";
static char const TRIBO_PLUGIN_NEON[] = "libtribo-neon.so";
#elif defined(__APPLE__)
#  include <dlfcn.h>
static char const TRIBO_PLUGIN_BASE[] = "libtribo-base.dylib";
static char const TRIBO_PLUGIN_AVX2[] = "libtribo-avx2.dylib";
static char const TRIBO_PLUGIN_NEON[] = "libtribo-neon.dylib";
#elif defined(_WIN32)
#  include <windows.h> // NOLINT(misc-include-cleaner)
static char const TRIBO_PLUGIN_BASE[] = "libtribo-base.dll";
static char const TRIBO_PLUGIN_AVX2[] = "libtribo-avx2.dll";
static char const TRIBO_PLUGIN_NEON[] = "libtribo-neon.dll";
#endif

#if defined(_WIN32)
#  define TRIBO_LOAD_FUNC(func) p->func = (tribo##func*)GetProcAddress((HMODULE)p->library, "tribo" #func);
#else
#  define TRIBO_LOAD_FUNC(func) p->func = (tribo##func*)dlsym(p->library, "tribo" #func);
#endif

#define TRIBO_LOAD_FUNC_WITH_CHECK(func)                                                                               \
  TRIBO_LOAD_FUNC(func)                                                                                                \
  if (!p->func) {                                                                                                      \
    (void)fprintf(stderr, "Failed to load function: tribo" #func "\n");                                                \
    return -1;                                                                                                         \
  }

static int iLoadFuncs(TriboUtilsPlugin* p) {

// ISO C forbids conversion of object pointer to function pointer type
#if defined(__GNUC__)
#  pragma GCC diagnostic push
#  pragma GCC diagnostic ignored "-Wpedantic"
#endif
  TRIBO_LOAD_FUNC_WITH_CHECK(Solve)
  TRIBO_LOAD_FUNC_WITH_CHECK(Free)
#if defined(__GNUC__)
#  pragma GCC diagnostic pop
#endif
  return 0;
}

static int iLoadLibrary(char const* const name, TriboUtilsPlugin* p) {

#ifdef _WIN32
  p->library = LoadLibraryA(name); // NOLINT(misc-include-cleaner)
#else
  p->library = dlopen(name, RTLD_NOW);
#endif

  if (!p->library) {
    return -1;
  }

  if (iLoadFuncs(p) != 0) {
    triboUtilsPluginUnload(p);
    return -1;
  }

  return 0;
}

static int iLoadDefaultPlugin(TriboUtilsPlugin* p) {

  if (triboUtilsIsaDetectAVX2() && iLoadLibrary(TRIBO_PLUGIN_AVX2, p) == 0) {
    return 0;
  }

  if (triboUtilsIsaDetectNEON() && iLoadLibrary(TRIBO_PLUGIN_NEON, p) == 0) {
    return 0;
  }

  if (iLoadLibrary(TRIBO_PLUGIN_BASE, p) == 0) {
    return 0;
  }
  return -1;
}

int triboUtilsPluginLoadFromPath(char const* const path, TriboUtilsPlugin* p) {

  if (!path && iLoadDefaultPlugin(p) != 0) {
    (void)fprintf(stderr, "No default plugins loaded successfully.\n");
    return -1;
  }

  if (path && iLoadLibrary(path, p) != 0) {
    (void)fprintf(stderr, "Failed to load plugin: %s\n", path);
    return -1;
  }

  return 0;
}

int triboUtilsPluginUnload(TriboUtilsPlugin* p) {
  if (!p || !p->library) {
    (void)fprintf(stderr, "Plugin already unloaded.\n");
    return -1;
  }
#ifdef _WIN32
  FreeLibrary((HMODULE)p->library); // NOLINT(misc-include-cleaner)
#else
  dlclose(p->library);
#endif

  p->library = NULL;
  p->Solve = NULL;
  p->Free = NULL;
  return 0;
}
