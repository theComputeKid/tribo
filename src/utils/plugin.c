#include "tribo/plugin.h"
#include "tribo/isa.h"
#include "tribo/log.h"
#include <stddef.h>

#if defined(__linux__)
#  include <dlfcn.h>
static char const TRIBO_PLUGIN_BASE[] = "libtribo-base.so";
static char const TRIBO_PLUGIN_AVX[] = "libtribo-avx.so";
static char const TRIBO_PLUGIN_NEON[] = "libtribo-neon.so";
#elif defined(__APPLE__)
#  include <dlfcn.h>
static char const TRIBO_PLUGIN_BASE[] = "libtribo-base.dylib";
static char const TRIBO_PLUGIN_AVX[] = "libtribo-avx.dylib";
static char const TRIBO_PLUGIN_NEON[] = "libtribo-neon.dylib";
#elif defined(_WIN32)
#  include <windows.h> // NOLINT(misc-include-cleaner)
static char const TRIBO_PLUGIN_BASE[] = "tribo-base.dll";
static char const TRIBO_PLUGIN_AVX[] = "tribo-avx.dll";
static char const TRIBO_PLUGIN_NEON[] = "tribo-neon.dll";
#endif

static int iLoadFunc(char const* const name, TriboUtilsPlugin* p) {
  TRIBO_LOG_INFO("Loading function: %s", name);

#ifdef _WIN32
  // NOLINTNEXTLINE(misc-include-cleaner)
  p->solver = (triboSolveFunc*)GetProcAddress((HMODULE)p->handle, name);
#else
  p->solver = (triboSolveFunc*)dlsym(p->handle, name);
#endif
  if (!p->solver) {
    TRIBO_LOG_ERROR("Failed to load function: %s", name);
    return -1;
  }
  TRIBO_LOG_INFO("Successfully loaded function: %s", name);
  return 0;
}

static int iLoadLibrary(char const* const name, TriboUtilsPlugin* p) {

  TRIBO_LOG_INFO("Loading plugin: %s", name);
#ifdef _WIN32
  p->handle = LoadLibraryA(name); // NOLINT(misc-include-cleaner)
#else
  p->handle = dlopen(name, RTLD_NOW);
#endif

  if (!p->handle) {
    TRIBO_LOG_ERROR("Failed to load plugin: %s", name);
    return -1;
  }

  if (iLoadFunc("triboSolve", p) != 0) {
    TRIBO_LOG_ERROR("Failed to load plugin: %s", name);
    triboUtilsPluginUnload(p);
    return -1;
  }

  TRIBO_LOG_INFO("Successfully loaded all plugin functions: %s", name);
  return 0;
}

static int iLoadDefaultPlugin(TriboUtilsPlugin* p) {
  TRIBO_LOG_INFO("%s", "Loading default plugins.");

  if (triboUtilsIsaDetectAVX() && iLoadLibrary(TRIBO_PLUGIN_AVX, p) == 0) {
    return 0;
  }

  if (triboUtilsIsaDetectNEON() && iLoadLibrary(TRIBO_PLUGIN_NEON, p) == 0) {
    return 0;
  }

  if (iLoadLibrary(TRIBO_PLUGIN_BASE, p) == 0) {
    return 0;
  }

  TRIBO_LOG_ERROR("%s", "No default plugins loaded successfully.");
  return -1;
}

int triboUtilsPluginLoadFromPath(char const* const path, TriboUtilsPlugin* p) {

  if (!path && iLoadDefaultPlugin(p) != 0) {
    return -1;
  }

  if (path && iLoadLibrary(path, p) != 0) {
    return -1;
  }

  return 0;
}

int triboUtilsPluginUnload(TriboUtilsPlugin* p) {
  if (!p || !p->handle) {
    TRIBO_LOG_ERROR("%s", "Plugin already unloaded.");
    return -1;
  }
#ifdef _WIN32
  FreeLibrary((HMODULE)p->handle); // NOLINT(misc-include-cleaner)
#else
  dlclose(p->handle);
#endif

  p->handle = NULL;
  p->solver = NULL;
  TRIBO_LOG_INFO("%s", "Plugin unloaded.");
  return 0;
}

int triboUtilsPluginSolve(TriboUtilsResults* results, TriboUtilsIniConfig const* config, TriboUtilsPlugin* plugin) {

  if (!plugin || !plugin->solver) {
    TRIBO_LOG_ERROR("%s", "Plugin not loaded.");
    return -1;
  }

  if (!config) {
    TRIBO_LOG_ERROR("%s", "Configuration not loaded.");
    return -1;
  }

  plugin->solver(results, config);
  return 0;
}
