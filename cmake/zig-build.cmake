# Zig Build Configuration

set(EXT "tar.xz")
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
    if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
        set(TARGET_ARCH "x86_64")
    elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86")
        set(TARGET_ARCH "x86")
    elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "aarch64")
        set(TARGET_ARCH "aarch64")
    else()
        message(FATAL_ERROR "linux: Unsupported architecture")
    endif()
    set(TARGET_PLATFORM "linux-musl")
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
        set(TARGET_ARCH "x86_64")
    elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86")
        set(TARGET_ARCH "x86")
    elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "aarch64")
        set(TARGET_ARCH "aarch64")
    else()
        message(FATAL_ERROR "windows: Unsupported architecture")
    endif()
    set(TARGET_PLATFORM "windows-gnu")
    set(EXT "zip")
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
    if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
        set(TARGET_ARCH "x86_64")
    elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "arm64")
        set(TARGET_ARCH "aarch64")
    else()
        message(FATAL_ERROR "macos: Unsupported architecture")
    endif()
    set(TARGET_PLATFORM "macos")
else()
    message(FATAL_ERROR "Unsupported platform")
endif()

if(NOT EXISTS "${CMAKE_BINARY_DIR}/zig-relsafe-espressif-${TARGET_ARCH}-${TARGET_PLATFORM}-baseline")
    file(DOWNLOAD "https://github.com/kassane/zig-espressif-bootstrap/releases/download/0.14.0-xtensa-dev/zig-relsafe-espressif-${TARGET_ARCH}-${TARGET_PLATFORM}-baseline.${EXT}"
        "${CMAKE_BINARY_DIR}/zig.${EXT}")

    if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
        execute_process(
            COMMAND powershell -Command "Expand-Archive -Path ${CMAKE_BINARY_DIR}/zig.${EXT} -DestinationPath ${CMAKE_BINARY_DIR}"
        )
    else()
        execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xf ${CMAKE_BINARY_DIR}/zig.${EXT}
            WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )
    endif()
else()
    message(STATUS "Zig already downloaded. Skipping zig install.")
endif()
set(ZIG_INSTALL ${CMAKE_BINARY_DIR}/zig-relsafe-espressif-${TARGET_ARCH}-${TARGET_PLATFORM}-baseline)

if(CONFIG_IDF_TARGET_ARCH_RISCV)
    set(ZIG_TARGET "riscv32-freestanding-none")
    if(CONFIG_IDF_TARGET_ESP32C6 OR CONFIG_IDF_TARGET_ESP32C5 OR CONFIG_IDF_TARGET_ESP32H2)
        set(TARGET_CPU_MODEL "generic_rv32+m+a+c+zicsr+zifencei")
    elseif(CONFIG_IDF_TARGET_ESP32P4)
        string(REGEX REPLACE "-none" "-eabihf" ZIG_TARGET ${ZIG_TARGET})
        # (zca, zcb, zcmt, zcmp) are not supported on ESP32-P4-Function-EV-Board (crash application)
        set(TARGET_CPU_MODEL "esp32p4-zca-zcb-zcmt-zcmp")
    else()
        set(TARGET_CPU_MODEL "generic_rv32+m+c+zicsr+zifencei")
    endif()
elseif(CONFIG_IDF_TARGET_ARCH_XTENSA)
    set(ZIG_TARGET "xtensa-freestanding-none")
    if(CONFIG_IDF_TARGET_ESP32)
        set(TARGET_CPU_MODEL "esp32")
    elseif(CONFIG_IDF_TARGET_ESP32S2)
        set(TARGET_CPU_MODEL "esp32s2")
    else(CONFIG_IDF_TARGET_ESP32S3)
        set(TARGET_CPU_MODEL "esp32s3")
    endif()
else()
    message(FATAL_ERROR "Unsupported target ${CONFIG_IDF_TARGET}")
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(ZIG_BUILD_TYPE "Debug")
else()
    set(ZIG_BUILD_TYPE "ReleaseSafe")
endif()

set(include_dirs $<TARGET_PROPERTY:${COMPONENT_LIB},INCLUDE_DIRECTORIES> ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES})
add_custom_target(zig_build
    COMMAND ${CMAKE_COMMAND} -E env
    "INCLUDE_DIRS=${include_dirs}"
    ${ZIG_INSTALL}/zig build
    --build-file ${BUILD_PATH}/build.zig
    -Doptimize=${ZIG_BUILD_TYPE}
    -Dtarget=${ZIG_TARGET}
    -Dcpu=${TARGET_CPU_MODEL}
    -freference-trace
    --prominent-compile-errors
    --cache-dir ${CMAKE_BINARY_DIR}/../.zig-cache
    --prefix ${CMAKE_BINARY_DIR}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    BYPRODUCTS ${CMAKE_BINARY_DIR}/lib/libapp_zig.a
    VERBATIM)

add_prebuilt_library(zig ${CMAKE_BINARY_DIR}/lib/libapp_zig.a)
add_dependencies(zig zig_build)
target_link_libraries(${COMPONENT_LIB} PRIVATE ${CMAKE_BINARY_DIR}/lib/libapp_zig.a)
