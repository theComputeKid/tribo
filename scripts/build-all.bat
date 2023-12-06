@REM * Builds everything for Windows. To be called from the project root directory. To perform a clean specify: clean-build

@echo off

if "%1%" == "clean-build" (
  if exist build\Windows rmdir /s /q build\Windows
)

@REM * Any step failing would fail this script.
call .\scripts\build-tools.bat || exit /b %errorlevel%
