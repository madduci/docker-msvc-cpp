@echo on

conan export . test/wine
conan install winetest/1.0.0@test/wine --build
