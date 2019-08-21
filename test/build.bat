@echo on

CALL C:\Tools\msvcenv_x64.bat

conan export . test/wine
conan install winetest/1.0.0@test/wine --build

CALL C:\Tools\msvcenv_x86.bat

conan install winetest/1.0.0@test/wine --build -s arch=x86