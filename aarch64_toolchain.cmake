set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set (TOOLCHAIN_PATH "/opt/xilinx-sdk-2019.1/sysroots/x86_64-petalinux-linux/usr/bin/aarch64-xilinx-linux")
set (CMAKE_SYSROOT /opt/xilinx-sdk-2019.1/sysroots/aarch64-xilinx-linux)
#set (SDKTARGETSYSROOT "/opt/xilinx-sdk-2019.1/sysroots/x86_64-petalinux-linux/usr/bin/aarch64-xilinx-linux")

set (CROSS_PREFIX           "aarch64-xilinx-linux-")
set (CMAKE_C_COMPILER       "${TOOLCHAIN_PATH}/${CROSS_PREFIX}gcc" CACHE PATH "" FORCE)
set (CMAKE_CXX_COMPILER     "${TOOLCHAIN_PATH}/${CROSS_PREFIX}g++" CACHE PATH "" FORCE)
set (CMAKE_C_FLAGS           "${CMAKE_C_FLAGS} -DZYNQ_XR1 -DLOG_FIFO_PLATFORM=3 -D__FILENAME__='\"$(notdir $(abspath $<))\"'")

set (CMAKE_C_COMPILER_WORKS 1)
set (CMAKE_CXX_COMPILER_WORKS 1)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

