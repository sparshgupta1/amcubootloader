set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set (TOOLCHAIN_PATH "/opt/Xilinx/SDK/2019.1/gnu/armr5/lin/gcc-arm-none-eabi/bin/")
set (CROSS_PREFIX           "${TOOLCHAIN_PATH}/armr5-none-eabi-")
set (CMAKE_C_COMPILER       "${CROSS_PREFIX}gcc" CACHE PATH "" FORCE)
set (CMAKE_CXX_COMPILER     "${CROSS_PREFIX}g++" CACHE PATH "" FORCE)
set (CMAKE_ASM_COMPILER     "${CROSS_PREFIX}gcc" CACHE PATH "" FORCE)

set (CMAKE_C_COMPILER_WORKS 1)
set (CMAKE_CXX_COMPILER_WORKS 1)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_C_FLAGS "-Os -mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16 -mfp16-format=ieee -Wall -Wextra -Werror -D__FILENAME__='\"$(notdir $(abspath $<))\"'")
set(CMAKE_CXX_FLAGS "-Os -mcpu=cortex-r5 -mfloat-abi=hard -mfpu=vfpv3-d16 -Wall -Wextra -Werror")
