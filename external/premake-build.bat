@echo off

if %PROCESSOR_ARCHITECTURE%==AMD64 (
  set PLATFORM=x64
)

if %PROCESSOR_ARCHITECTURE%==ARM64 (
  set PLATFORM=ARM64
)

cd premake-core && Bootstrap.bat && copy bin\release\premake5.exe ..\..
.\..\..\premake5.exe --version
