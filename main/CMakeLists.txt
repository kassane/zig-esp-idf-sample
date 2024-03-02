idf_component_register(SRCS "main.c"
    INCLUDE_DIRS ".")
set(include_dirs $<TARGET_PROPERTY:${COMPONENT_LIB},INCLUDE_DIRECTORIES> ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES})
set(link_libs $<TARGET_PROPERTY:${COMPONENT_LIB},LINK_LIBRARIES> ${CMAKE_C_IMPLICIT_LINK_LIBRARIES})

if(CONFIG_IDF_TARGET_ARCH_RISCV)
    set(ZIG_TARGET "riscv32-freestanding-none")
    if(CONFIG_IDF_TARGET_ESP32C6 OR CONFIG_IDF_TARGET_ESP32C5 OR CONFIG_IDF_TARGET_ESP32H2)
        set(TARGET_CPU_MODEL "generic_rv32+m+a+c")
    elseif(CONFIG_IDF_TARGET_ESP32P4)
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
    set(ZIG_BUILD_TYPE "ReleaseSmall")
endif()

add_custom_target(zig_build
    COMMAND ${CMAKE_COMMAND} -E env
    "INCLUDE_DIRS=${include_dirs}"
    "LIBRARIES=${link_libs}"
    zig build
    --build-file ${CMAKE_CURRENT_SOURCE_DIR}/build.zig
    -Doptimize=${ZIG_BUILD_TYPE}
    -Dtarget=${ZIG_TARGET}
    -Dcpu=${TARGET_CPU_MODEL}
    --cache-dir ${CMAKE_BINARY_DIR}/zig-cache
    --prefix ${CMAKE_BINARY_DIR}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    BYPRODUCTS ${CMAKE_BINARY_DIR}/lib/libzig.a
    VERBATIM)

add_prebuilt_library(zig ${CMAKE_CURRENT_BINARY_DIR}/lib/libzig.a)
add_dependencies(zig zig_build)
target_link_libraries(${COMPONENT_LIB} PRIVATE ${CMAKE_BINARY_DIR}/lib/libzig.a)
