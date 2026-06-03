cmake_minimum_required(VERSION 3.5.1 FATAL_ERROR)
include($ENV{TAPASCO_HOME_RUNTIME}/cmake/Tapasco.cmake NO_POLICY_SCOPE)

message(STATUS "C++ compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "C++ compiler ID: ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "C++ compiler version: ${CMAKE_CXX_COMPILER_VERSION}")

project(suspmv LANGUAGES CXX)

if(NOT TARGET tapasco)
    find_package(Tapasco REQUIRED)
endif()

find_package(Threads)

add_executable(suspmv src/main.cpp src/dump_hex.cpp src/matrix.cpp)
set_tapasco_defaults(suspmv)
target_link_libraries(suspmv PRIVATE tapasco)
target_compile_options(suspmv PRIVATE -Wno-error)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

target_compile_options(suspmv PRIVATE -std=c++20 -O3)
