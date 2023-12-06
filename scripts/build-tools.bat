@REM * Helper script to build tools if they are not present on the system.
cmake -S . -B build/Windows/tools ^
-DCMAKE_BUILD_TYPE=Release ^
-DCMAKE_INSTALL_PREFIX=build/Windows/tools/install -DTRIBO_BUILD_TOOLS=ON && ^
cmake --build build/Windows/tools --config Release
