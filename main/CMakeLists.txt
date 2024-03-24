set(DEPS pthread driver)
idf_component_register(SRCS "placeholder.c"
    INCLUDE_DIRS "."
    PRIV_REQUIRES "${DEPS}"
)
set(include_dirs $<TARGET_PROPERTY:${COMPONENT_LIB},INCLUDE_DIRECTORIES> ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES})
set(link_libs $<TARGET_PROPERTY:${COMPONENT_LIB},LINK_LIBRARIES> ${CMAKE_C_IMPLICIT_LINK_LIBRARIES})


# Detect target architecture and platform
if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
    set(TARGET_ARCH "x86_64")
elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "aarch64")
    set(TARGET_ARCH "aarch64")
else()
    message(FATAL_ERROR "Unsupported architecture")
endif()

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
    set(TARGET_PLATFORM "linux-musl")
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set(TARGET_PLATFORM "windows-gnu")
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
    set(TARGET_PLATFORM "macos-none")
else()
    message(FATAL_ERROR "Unsupported platform")
endif()

if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/zig-${TARGET_ARCH}-relsafe-espressif-${TARGET_PLATFORM}-baseline")
    file(DOWNLOAD "https://github.com/kassane/zig-espressif-bootstrap/releases/download/0.12.0-dev/zig-${TARGET_ARCH}-relsafe-espressif-${TARGET_PLATFORM}-baseline.tar.xz"
        "${CMAKE_CURRENT_BINARY_DIR}/zig.tar.xz")

    if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
        execute_process(
            COMMAND powershell -Command "Expand-Archive -Path ${CMAKE_CURRENT_BINARY_DIR}/zig.tar.xz -DestinationPath ${CMAKE_CURRENT_BINARY_DIR}"
        )
    else()
        execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xf ${CMAKE_CURRENT_BINARY_DIR}/zig.tar.xz
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )
    endif()
else()
    message(STATUS "Zig already downloaded. Skipping zig install.")
endif()
set(ZIG_INSTALL ${CMAKE_CURRENT_BINARY_DIR}/zig-${TARGET_ARCH}-relsafe-espressif-${TARGET_PLATFORM}-baseline)

if(CONFIG_IDF_TARGET_ARCH_RISCV)
    set(ZIG_TARGET "riscv32-freestanding-none")
    if(CONFIG_IDF_TARGET_ESP32C6 OR CONFIG_IDF_TARGET_ESP32C5 OR CONFIG_IDF_TARGET_ESP32H2)
        set(TARGET_CPU_MODEL "generic_rv32+m+a+c")
    elseif(CONFIG_IDF_TARGET_ESP32P4)
        set(ZIG_TARGET "riscv32-freestanding-eabihf")
        set(TARGET_CPU_MODEL "generic_rv32+m+a+c+f")
    else()
        set(TARGET_CPU_MODEL "generic_rv32+m+c")
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

add_custom_target(zig_build
    COMMAND ${CMAKE_COMMAND} -E env
    "INCLUDE_DIRS=${include_dirs}"
    "LIBRARIES=${link_libs}"
    ${ZIG_INSTALL}/zig build
    --build-file ${BUILD_PATH}/build.zig
    -Doptimize=${ZIG_BUILD_TYPE}
    -Dtarget=${ZIG_TARGET}
    -Dcpu=${TARGET_CPU_MODEL}
    -freference-trace
    --prominent-compile-errors
    --cache-dir ${CMAKE_BINARY_DIR}/zig-cache
    --prefix ${CMAKE_BINARY_DIR}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    BYPRODUCTS ${CMAKE_BINARY_DIR}/lib/libzig.a
    VERBATIM)

add_prebuilt_library(zig ${CMAKE_CURRENT_BINARY_DIR}/lib/libzig.a)
add_dependencies(zig zig_build)
target_link_libraries(${COMPONENT_LIB} PRIVATE ${CMAKE_BINARY_DIR}/lib/libzig.a)
