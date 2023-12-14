<div align="center">
	<h1>Build Instructions</h1>
  <a href="../README.md"><strong>home</strong></a>
</div>

### Requirements

The following tools are needed to build the project:

- cmake >= v3.28
- ninja >= v1.11

If an older version of cmake or ninja is present on the system, then a convenience script is provided that can download and build the latest version of cmake and ninja, though that script still requires a version of cmake >= 3.10 already on the system. To use the convenience script for Linux/MacOS, run this command from the project root directory:

```
./scripts/build-tools.sh
```

To use the convenience script for Windows, run this command from the project root directory:

```
.\scripts\build-tools.bat
```

Once CMake and ninja have been built, the newly installed CMake can be invoked conveniently by another helper script. On Linux/MacOS:

```
./scripts/cmake.sh
```

On Windows:

```
.\scripts\cmake.bat
```

Note that the helper script redirects all arguments provided to it to the newly built CMake, so it should be used as if it was the CMake executable itself. For example:

```
./scripts/cmake.sh --version
```

### Build

For a minimal release production build:

```
cmake --workflow --preset minimal
```

This also generates [documentation](#api-documentation) if doxygen is present on the build system.

### Development

To list all the available CMake presets, including those used in development:

```
cmake --workflow --list-presets
```

Three configurations are provided for every supported compiler:
- Debug:
  - Optimisations disabled.
  - Debugging symbols enabled.
- Release:
  - Optimisations enabled.
  - Debugging symbols disabled.
- CodeCheck:
  - Optimisations disabled.
  - Debugging symbols enabled.
  - Address sanitisation enabled.
  - Static analysis checks enabled.

[Documentation](#api-documentation) and tests are built with all development configurations.

### API documentation

If doxygen is present on the build system, then documentation for the project API is automatically generated [`build/html/index.html`](build/html/index.html). However, this is not checked in to the repository and the project must be built for it to happen.
