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
    if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64" OR CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "AMD64")
        set(TARGET_ARCH "x86_64")
    elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86")
        set(TARGET_ARCH "x86")
    elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "arm64")
        set(TARGET_ARCH "aarch64")
    else()
        message(FATAL_ERROR "windows: Unsupported architecture ${CMAKE_HOST_SYSTEM_PROCESSOR}")
    endif()
    set(TARGET_PLATFORM "windows")
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

find_program(SYSTEM_ZIG_BIN zig)

if(SYSTEM_ZIG_BIN AND CONFIG_IDF_TARGET_ARCH_RISCV)
    if(CONFIG_IDF_TARGET_ESP32P4)
        set(USE_ZIG_ESPRESSIF_TOOLCHAIN TRUE)
    else()
        set(USE_ZIG_ESPRESSIF_TOOLCHAIN FALSE)
    endif()
else()
    set(USE_ZIG_ESPRESSIF_TOOLCHAIN TRUE)
endif()

if(USE_ZIG_ESPRESSIF_TOOLCHAIN)
    if(NOT EXISTS "${CMAKE_BINARY_DIR}/zig-relsafe-${TARGET_ARCH}-${TARGET_PLATFORM}-baseline")
        set(ZIG_DOWNLOAD_LINK "https://github.com/kassane/zig-espressif-bootstrap/releases/download/0.16.0-xtensa-dev/zig-relsafe-${TARGET_ARCH}-${TARGET_PLATFORM}-baseline.${EXT}")
        message(STATUS "Downloading ${ZIG_DOWNLOAD_LINK} to ${CMAKE_BINARY_DIR}/zig.${EXT}")

        file(DOWNLOAD "${ZIG_DOWNLOAD_LINK}" "${CMAKE_BINARY_DIR}/zig.${EXT}" SHOW_PROGRESS)

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
    set(ZIG_BIN ${CMAKE_BINARY_DIR}/zig-relsafe-${TARGET_ARCH}-${TARGET_PLATFORM}-baseline/zig)
else()
    set(ZIG_BIN ${SYSTEM_ZIG_BIN})
endif()

if(CONFIG_IDF_TARGET_ARCH_RISCV)
    set(TARGET_IDF_ARCH "riscv")
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
    set(TARGET_IDF_ARCH "xtensa")
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

if(CONFIG_IDF_TARGET_ESP32)
    set(TARGET_IDF_MODEL "esp32")
elseif(CONFIG_IDF_TARGET_ESP32C2)
    set(TARGET_IDF_MODEL "esp32c2")
elseif(CONFIG_IDF_TARGET_ESP32C3)
    set(TARGET_IDF_MODEL "esp32c3")
elseif(CONFIG_IDF_TARGET_ESP32C6)
    set(TARGET_IDF_MODEL "esp32c6")
elseif(CONFIG_IDF_TARGET_ESP32H2)
    set(TARGET_IDF_MODEL "esp32h2")
elseif(CONFIG_IDF_TARGET_ESP32P4)
    set(TARGET_IDF_MODEL "esp32p4")
elseif(CONFIG_IDF_TARGET_ESP32S2)
    set(TARGET_IDF_MODEL "esp32s2")
elseif(CONFIG_IDF_TARGET_ESP32S3)
    set(TARGET_IDF_MODEL "esp32s3")
else()
    message(FATAL_ERROR "Unknown IDF target")
endif()

# Check Toolchain version
get_filename_component(TOOLCHAIN_BIN_DIR "${CMAKE_C_COMPILER}" DIRECTORY)
get_filename_component(TOOLCHAIN_VERSION_DIR "${TOOLCHAIN_BIN_DIR}" DIRECTORY)
if(NOT TOOLCHAIN_VERSION_DIR MATCHES "esp-[0-9]+\\.[0-9]+\\.[0-9]+_[0-9]+")
    message(WARNING "TOOLCHAIN_VERSION_DIR '${TOOLCHAIN_VERSION_DIR}' does not look like a standard ESP toolchain version folder. Using as-is.")
endif()
message(STATUS "Detected toolchain version directory: ${TOOLCHAIN_VERSION_DIR}")

if(CONFIG_IDF_TARGET_ARCH_RISCV)
    set(ARCH "riscv")
    if(DEFINED ENV{IDF_TOOLS_PATH})
        if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
            file(TO_CMAKE_PATH "$ENV{IDF_TOOLS_PATH}" IDF_TOOLS_PATH_NORMALIZED)
            set(TOOLCHAIN_BASE_PATH "${IDF_TOOLS_PATH_NORMALIZED}/tools/riscv32-esp-elf")
        else()
            set(TOOLCHAIN_BASE_PATH "$ENV{IDF_TOOLS_PATH}/tools/riscv32-esp-elf")
        endif()
    else()
        set(TOOLCHAIN_BASE_PATH "$ENV{HOME}/.espressif/tools/riscv32-esp-elf")
    endif()
    set(TOOLCHAIN_ELF_INCLUDE "${TOOLCHAIN_VERSION_DIR}/riscv32-esp-elf/include")
    # Define the toolchain include paths
    if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
        # Windows has no sys-include folder
        set(TOOLCHAIN_SYS_INCLUDE "${TOOLCHAIN_ELF_INCLUDE}/sys")
    else()
        set(TOOLCHAIN_SYS_INCLUDE "${TOOLCHAIN_BASE_PATH}/sys-include")
    endif()
    set(ARCH_DEFINE "__riscv")
elseif(CONFIG_IDF_TARGET_ARCH_XTENSA)
    set(ARCH "xtensa")
    if(DEFINED ENV{IDF_TOOLS_PATH})
        if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
            file(TO_CMAKE_PATH "$ENV{IDF_TOOLS_PATH}" IDF_TOOLS_PATH_NORMALIZED)
            set(TOOLCHAIN_BASE_PATH "${IDF_TOOLS_PATH_NORMALIZED}/tools/xtensa-esp-elf")
        else()
            set(TOOLCHAIN_BASE_PATH "$ENV{IDF_TOOLS_PATH}/tools/xtensa-esp-elf")
        endif()
    else()
        set(TOOLCHAIN_BASE_PATH "$ENV{HOME}/.espressif/tools/xtensa-esp-elf")
    endif()
    set(TOOLCHAIN_ELF_INCLUDE "${TOOLCHAIN_VERSION_DIR}/xtensa-esp-elf/include")
    if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
        # Windows has no sys-include folder
        set(TOOLCHAIN_SYS_INCLUDE "${TOOLCHAIN_ELF_INCLUDE}/sys")
    else()
        set(TOOLCHAIN_SYS_INCLUDE "${TOOLCHAIN_BASE_PATH}/sys-include")
    endif()
    set(ARCH_DEFINE "__XTENSA__")
endif()

set(INCLUDE_DIRS
    "${IDF_PATH}/components/freertos/FreeRTOS-Kernel/include"
    "${IDF_PATH}/components/freertos/config/include/freertos"
    "${IDF_PATH}/components/freertos/config/${ARCH}/include"
    "${IDF_PATH}/components/freertos/FreeRTOS-Kernel-SMP/portable/${ARCH}/include/freertos"
    "${IDF_PATH}/components/esp_hw_support/include"
    "${IDF_PATH}/components/soc/include"
    "${IDF_PATH}/components/soc/${TARGET_IDF_MODEL}/include"
    "${IDF_PATH}/components/esp_common/include"
    "${IDF_PATH}/components/hal/include"
    "${IDF_PATH}/components/${ARCH}/include"
    "${IDF_PATH}/components/${ARCH}/${TARGET_IDF_MODEL}/include"
    "${IDF_PATH}/components/${ARCH}/${TARGET_IDF_MODEL}/include/${ARCH}"
    "${IDF_PATH}/components/${ARCH}/${TARGET_IDF_MODEL}/include/${ARCH}/config"
    "${IDF_PATH}/components/${ARCH}/${TARGET_IDF_MODEL}/include/${ARCH}/core"
    "${IDF_PATH}/components/soc/${TARGET_IDF_MODEL}/register"
    "${IDF_PATH}/components/esp_system/include"
    "${IDF_PATH}/components/esp_driver_gpio/include"
    "${IDF_PATH}/components/esp_hw_support/etm/include"
    "${IDF_PATH}/components/esp_hal_ana_cmpr/include"
    "${IDF_PATH}/components/esp_hal_ana_conv/include"
    "${IDF_PATH}/components/esp_hal_cam/include"
    "${IDF_PATH}/components/esp_hal_dma/include"
    "${IDF_PATH}/components/esp_hal_gpio/include"
    "${IDF_PATH}/components/esp_hal_gpspi/include"
    "${IDF_PATH}/components/esp_hal_i2c/include"
    "${IDF_PATH}/components/esp_hal_i2s/include"
    "${IDF_PATH}/components/esp_hal_lcd/include"
    "${IDF_PATH}/components/esp_hal_ledc/include"
    "${IDF_PATH}/components/esp_hal_mcpwm/include"
    "${IDF_PATH}/components/esp_hal_mspi/include"
    "${IDF_PATH}/components/esp_hal_parlio/include"
    "${IDF_PATH}/components/esp_hal_pcnt/include"
    "${IDF_PATH}/components/esp_hal_ppa/include"
    "${IDF_PATH}/components/esp_hal_rmt/include"
    "${IDF_PATH}/components/esp_hal_timg/include"
    "${IDF_PATH}/components/esp_hal_touch_sens/include"
    "${IDF_PATH}/components/esp_hal_twai/include"
    "${IDF_PATH}/components/esp_hal_uart/include"
    "${IDF_PATH}/components/esp_hal_usb/include"
    "${IDF_PATH}/components/esp_hal_wdt/include"
    "${IDF_PATH}/components/esp_phy/include"
    "${IDF_PATH}/components/esp_blockdev/include"
    "${IDF_PATH}/components/esp_libc/platform_include"
    "${IDF_PATH}/components/newlib"
    "${IDF_PATH}/components/newlib/platform_include/sys"
    "${IDF_PATH}/components/newlib/platform_include"
    "${IDF_PATH}/components/hal/platform_port/include"
    "${IDF_PATH}/components/heap/include"
    "${IDF_PATH}/components/esp_rom/include"
    "${IDF_PATH}/components/esp_wifi/include"
    "${IDF_PATH}/components/esp_event/include"
    "${IDF_PATH}/components/lwip/include"
    "${IDF_PATH}/components/lwip/port/include"
    "${IDF_PATH}/components/freertos/config/include"
    "${IDF_PATH}/components/lwip/port/freertos/include"
    "${IDF_PATH}/components/lwip/port/esp32xx/include"
    "${IDF_PATH}/components/log/include"
    "${IDF_PATH}/components/nvs_flash/include"
    "${IDF_PATH}/components/esp_partition/include"
    "${IDF_PATH}/components/esp_netif/include"
    "${IDF_PATH}/components/esp_event/include"
    "${IDF_PATH}/components/driver/i2c/include"
    "${IDF_PATH}/components/esp_driver_uart/include"
    "${IDF_PATH}/components/esp_driver_spi/include"
    "${IDF_PATH}/components/spi_flash/include"
    "${IDF_PATH}/components/esp_driver_i2s/include"
    "${CMAKE_SOURCE_DIR}/build/config"
    "${TOOLCHAIN_SYS_INCLUDE}"
    "${TOOLCHAIN_ELF_INCLUDE}"
)

set(INCLUDE_FLAGS "")
foreach(dir ${INCLUDE_DIRS})
    set(INCLUDE_FLAGS "${INCLUDE_FLAGS} -I\"${dir}\"")
endforeach()
separate_arguments(INCLUDE_FLAGS UNIX_COMMAND "${INCLUDE_FLAGS}")

string(TOUPPER "${TARGET_IDF_MODEL}" TARGET_IDF_MODEL_UPPER)
set(DEFINE_FLAGS
    "-Dtarget=${ZIG_TARGET}"
    "-Dmcpu=${TARGET_IDF_MODEL}"
    "-D__${TARGET_IDF_ARCH}"
    "-D${ARCH_DEFINE}"
    "-Dcpu_${TARGET_CPU_MODEL}"
    "-DCONFIG_IDF_TARGET_${TARGET_IDF_MODEL_UPPER}"
    "-D__COUNTER__=0"
    "-DIRAM_ATTR="
    "-D_SECTION_ATTR_IMPL\\(x,y\\)="
    "-DSOC_MMU_PAGE_SIZE=0x8000"
    "-DLWIP_NO_UNISTD_H=")
string(JOIN " " DEFINE_FLAGS_STR ${DEFINE_FLAGS})

if(ARCH_DEFINE)
    set(DEFINE_FLAGS "${DEFINE_FLAGS} -D${ARCH_DEFINE}")
endif()

set(IDF_SYS_ZIG "${CMAKE_SOURCE_DIR}/imports/idf-sys.zig")
set(IDF_SYS_C "${CMAKE_SOURCE_DIR}/include/stubs.h")

# Run `translate-c` to generate `idf-sys.zig`
add_custom_command(
    OUTPUT "${IDF_SYS_ZIG}"
    COMMAND ${ZIG_BIN} translate-c ${DEFINE_FLAGS} ${INCLUDE_FLAGS} ${IDF_SYS_C} > ${IDF_SYS_ZIG}
    DEPENDS ${IDF_SYS_C}
)

# Ensure `translate_c` runs before modifying the file
add_custom_target(translate_c ALL DEPENDS "${IDF_SYS_ZIG}")
set_property(TARGET translate_c PROPERTY GENERATED TRUE)

set(IDF_SYS_ZIG "${CMAKE_SOURCE_DIR}/imports/idf-sys.zig")
message(STATUS "IDF_SYS_ZIG is set to: ${IDF_SYS_ZIG}")

add_custom_command(
    TARGET translate_c
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -D TARGET_FILE="${IDF_SYS_ZIG}" -D CONFIG_IDF_TARGET_ESP32P4="${CONFIG_IDF_TARGET_ESP32P4}" -P ${CMAKE_SOURCE_DIR}/cmake/patch.cmake
    COMMAND ${CMAKE_COMMAND} -E touch "${CMAKE_BINARY_DIR}/patches_applied.done"
)


if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(ZIG_BUILD_TYPE "Debug")
else()
    set(ZIG_BUILD_TYPE "ReleaseSafe")
endif()

# set(ZIG_CACHE_DIR ${CMAKE_BINARY_DIR}/.zig-cache)
set(include_dirs $<TARGET_PROPERTY:${COMPONENT_LIB},INCLUDE_DIRECTORIES> ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES})
add_custom_target(zig_build
    COMMAND ${CMAKE_COMMAND} -E env
    "INCLUDE_DIRS=${include_dirs}"
    ${ZIG_BIN} build
    --build-file ${BUILD_PATH}/build.zig
    -Doptimize=${ZIG_BUILD_TYPE}
    -Dtarget=${ZIG_TARGET}
    -Dcpu=${TARGET_CPU_MODEL}
    -freference-trace
    --cache-dir ${CMAKE_BINARY_DIR}/../.zig-cache
    --prefix ${CMAKE_BINARY_DIR}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    BYPRODUCTS ${CMAKE_BINARY_DIR}/lib/libapp_zig.a
    VERBATIM)

add_dependencies(zig_build translate_c)
add_library(app_zig STATIC IMPORTED)
set_target_properties(app_zig PROPERTIES IMPORTED_LOCATION ${CMAKE_BINARY_DIR}/lib/libapp_zig.a)
add_dependencies(app_zig zig_build)

add_prebuilt_library(zig ${CMAKE_BINARY_DIR}/lib/libapp_zig.a)
add_dependencies(${COMPONENT_LIB} zig_build)


target_link_libraries(${COMPONENT_LIB} PRIVATE ${CMAKE_BINARY_DIR}/lib/libapp_zig.a)

# ESP32-H2/P4 does not have wifi support
if(NOT CONFIG_IDF_TARGET_ESP32P4)
    list(APPEND ESP32_LIBS
        ${IDF_PATH}/components/esp_phy/lib/${TARGET_IDF_MODEL}/libphy.a
    )
endif()


if(NOT CONFIG_IDF_TARGET_ESP32P4 AND NOT CONFIG_IDF_TARGET_ESP32H2)
    list(APPEND ESP32_LIBS
        ${IDF_PATH}/components/esp_wifi/lib/${TARGET_IDF_MODEL}/libpp.a
        ${IDF_PATH}/components/esp_wifi/lib/${TARGET_IDF_MODEL}/libmesh.a
        ${IDF_PATH}/components/esp_wifi/lib/${TARGET_IDF_MODEL}/libnet80211.a
        ${IDF_PATH}/components/esp_wifi/lib/${TARGET_IDF_MODEL}/libcore.a
        ${CMAKE_BINARY_DIR}/esp-idf/wpa_supplicant/libwpa_supplicant.a
    )
endif()


message(STATUS "Wifi Libs: ${ESP32_LIBS}")

target_link_libraries(${COMPONENT_LIB} PRIVATE
    "-Wl,--start-group"
    ${ESP32_LIBS}
    ${CMAKE_BINARY_DIR}/esp-idf/log/liblog.a
    ${CMAKE_BINARY_DIR}/esp-idf/nvs_flash/libnvs_flash.a
    ${CMAKE_BINARY_DIR}/esp-idf/soc/libsoc.a
    ${CMAKE_BINARY_DIR}/esp-idf/esp_hw_support/libesp_hw_support.a
    ${CMAKE_BINARY_DIR}/esp-idf/hal/libhal.a
    # ${CMAKE_BINARY_DIR}/esp-idf/mbedtls/mbedtls/library/libmbedcrypto.a
    ${CMAKE_BINARY_DIR}/esp-idf/freertos/libfreertos.a
    ${CMAKE_BINARY_DIR}/esp-idf/lwip/liblwip.a
    ${CMAKE_BINARY_DIR}/esp-idf/esp_wifi/libesp_wifi.a
    ${CMAKE_BINARY_DIR}/esp-idf/esp_netif/libesp_netif.a
    ${CMAKE_BINARY_DIR}/esp-idf/esp_event/libesp_event.a
    ${CMAKE_BINARY_DIR}/lib/libapp_zig.a
    "-Wl,--end-group"
)
