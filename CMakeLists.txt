# The following lines of boilerplate have to be in your project's
# CMakeLists in this exact order for cmake to work correctly
cmake_minimum_required(VERSION 3.20)

include($ENV{IDF_PATH}/tools/cmake/project.cmake)
project(zig-sample-idf)

idf_build_get_property(comps BUILD_COMPONENTS)
set(BUILD_COMPONENTS ${comps} CACHE STRING "all esp-idf components" FORCE)
