<div align="center">
	<h1>Build Instructions</h1>
  <a href="../README.md"><strong>home</strong></a>
</div>

### Requirements

The following tools are needed to build the project:

- cmake >= v3.28 (required)
- ninja >= v1.11 (recommended)

If an older version of cmake is present on the system, then a convenience script is provided that can download and build the latest version of cmake and ninja, though that script still requires a version of cmake >= 3.2 already on the system. To use the convenience script for Linux/MacOS, run this command from the project root directory:

```
./scripts/build-tools.sh
```

To use the convenience script for Windows, run this command from the project root directory:

```
./scripts/build-tools.bat
```

Once CMake and ninja have been built, the newly installed CMake can be invoked conveniently by another helper script. On Linux/MacOS:

```
./scripts/cmake.sh
```

On Windows:

```
./scripts/cmake.bat
```

Note that the helper script redirects all arguments provided to it to the newly built CMake, so it should be used as if it was the CMake executable itself. For example:

```
./scripts/cmake.sh --workflow --list-presets
```
