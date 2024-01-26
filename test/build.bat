@echo on

setlocal
cd /d %~dp0
md build
cd build

REM Perform Conan Setup
conan export --name winetest ..
conan install --name winetest --no-remote --output-folder . --build=missing ..

REM Build with CMake
cmake --preset conan-release ..
cmake --build --preset conan-release

REM Run the Application
winetest.exe
