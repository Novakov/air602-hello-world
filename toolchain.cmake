SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_CROSSCOMPILING 1)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_SYSTEM_PROCESSOR armv6)

set(TOOLCHAIN D:/Toolchains/arm-none-eabi/bin)

find_program(CMAKE_C_COMPILER NAMES arm-none-eabi-gcc PATHS ${TOOLCHAIN})
find_program(CMAKE_CXX_COMPILER NAMES arm-none-eabi-g++ PATHS ${TOOLCHAIN})
find_program(CMAKE_AR NAMES arm-none-eabi-gcc-ar PATHS ${TOOLCHAIN})
find_program(CMAKE_RANLIB NAMES arm-none-eabi-gcc-ranlib PATHS ${TOOLCHAIN})
find_program(CMAKE_OBJCOPY NAMES arm-none-eabi-objcopy PATHS ${TOOLCHAIN})
find_program(CMAKE_OBJDUMP NAMES arm-none-eabi-objdump PATHS ${TOOLCHAIN})
find_program(CMAKE_GCC_SIZE NAMES arm-none-eabi-size PATHS ${TOOLCHAIN})

set(CMAKE_EXECUTABLE_FORMAT ELF)

set(COMPILER_FLAGS "-mcpu=cortex-m3 -mthumb -ffunction-sections -fdata-sections -Og")
set(CMAKE_CXX_STANDARD 14)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${COMPILER_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${COMPILER_FLAGS} -std=c++14")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -specs=nano.specs -specs=nosys.specs -Wl,--gc-sections")

add_definitions(
    -DIN_ADDR_T_DEFINED
    -DLWIP_TIMEVAL_PRIVATE=0
    -DTLS_OS_FREERTOS=1
)

find_package (Python3 COMPONENTS Interpreter)