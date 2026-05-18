cmake_minimum_required(VERSION 3.5.1 FATAL_ERROR)
#include($ENV{TAPASCO_HOME_RUNTIME}/cmake/Tapasco.cmake NO_POLICY_SCOPE)

project(suspmv LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

#if(NOT TARGET tapasco)
#    find_package(Tapasco REQUIRED)
#endif()

find_package(Threads)

add_executable(suspmv src/main.cpp src/matrix.cpp)
#set_tapasco_defaults(suspmv)
#target_link_libraries(suspmv PRIVATE tapasco)
