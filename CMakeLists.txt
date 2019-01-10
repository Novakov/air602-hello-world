cmake_minimum_required(VERSION 3.1)

set(LOCAL_CFG "" CACHE FILEPATH "Path to local config")

if(NOT LOCAL_CFG)
    message(FATAL_ERROR "LOCAL_CFG variable not set. Use -DLOCAL_CFG=<file> to set local config. See local-example.cmake for available options")
endif()

message(STATUS "Using local config from ${LOCAL_CFG}")
include(${LOCAL_CFG})

include(toolchain.cmake)

project(MyProject C CXX ASM)

set(OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/build/${TARGET_PLATFORM})
set(REPORTS_PATH ${OUTPUT_PATH}/reports)

file(MAKE_DIRECTORY ${OUTPUT_PATH})

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_PATH}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_PATH}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_PATH}/bin)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "" FORCE)
else()
    set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "" FORCE)
endif()

include(cmake/formats.cmake)
include(cmake/wm.cmake)

add_subdirectory(hello_world)
add_subdirectory(libs)