cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

project(winetest CXX)
set(PROJECT_VERSION 1.0.0)

add_executable(${PROJECT_NAME} test.cpp)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup(TARGETS)

set_target_properties(${MODULE_NAME_TEST} PROPERTIES CXX_STANDARD 17)
set_target_properties(${MODULE_NAME_TEST} PROPERTIES CXX_STANDARD_REQUIRED ON)
set_target_properties(${MODULE_NAME_TEST} PROPERTIES CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4 /WX /GL /Yu")
set_target_properties(${MODULE_NAME_TEST} PROPERTIES CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /W4 /WX /GL /Yu")
set_target_properties(${MODULE_NAME_TEST} PROPERTIES CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /W4 /WX /GL /Yu")

# Fixes CMake error with Windows style paths
set(MSVC_REDIST_DIR $ENV{VCToolsRedistDir})
string(REPLACE  "\\" "/" MSVC_REDIST_DIR "${MSVC_REDIST_DIR}")

include(InstallRequiredSystemLibraries)

install(TARGETS ${PROJECT_NAME}
 RUNTIME DESTINATION bin
 LIBRARY DESTINATION lib
 ARCHIVE DESTINATION lib)


set(CPACK_GENERATOR WIX)
# LIGHT216 error while building MSI package under wine
set(CPACK_WIX_LIGHT_EXTRA_FLAGS -sval )
include(CPack)