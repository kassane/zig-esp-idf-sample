# ──────────────────────────────────────────────────────────────────────────────
# Zig configuration for ESP-IDF (esp32 xtensa/riscv targets)
# ──────────────────────────────────────────────────────────────────────────────

set(ZIG_MIN_VERSION "0.16.0")

# ─── Host platform & architecture detection ──────────────────────────────────
cmake_host_system_information(RESULT HOST_OS QUERY OS_NAME)
string(TOLOWER "${HOST_OS}" HOST_OS_LOWER)

set(HOST_ARCH "${CMAKE_HOST_SYSTEM_PROCESSOR}")

# Normalize to Zig-style triple names
if(HOST_ARCH MATCHES "^(AMD64|amd64|x86_64|X64)$")
    set(ZIG_ARCH "x86_64")
elseif(HOST_ARCH MATCHES "^(aarch64|arm64|ARM64)$")
    set(ZIG_ARCH "aarch64")
elseif(HOST_ARCH MATCHES "^(x86|i686|i386|i[345]86)$")
    set(ZIG_ARCH "x86")
else()
    message(FATAL_ERROR "Unsupported host architecture '${HOST_ARCH}'.\n"
        "Please report:\n"
        "  CMAKE_HOST_SYSTEM_PROCESSOR = ${CMAKE_HOST_SYSTEM_PROCESSOR}\n"
        "  cmake --system-information | findstr PROCESSOR")
endif()

# Platform + extension
if(HOST_OS_LOWER MATCHES "(linux|unix)")
    set(ZIG_PLATFORM "linux-musl")
    set(ARCHIVE_EXT "tar.xz")
elseif(HOST_OS_LOWER MATCHES "windows|win")
    set(ZIG_PLATFORM "windows")
    set(ARCHIVE_EXT "zip")
elseif(HOST_OS_LOWER MATCHES "darwin|mac|osx")
    set(ZIG_PLATFORM "macos")
    set(ARCHIVE_EXT "tar.xz")
else()
    message(FATAL_ERROR "Unsupported host OS: ${HOST_OS}")
endif()

set(ZIG_TRIPLET "${ZIG_ARCH}-${ZIG_PLATFORM}-baseline")
set(ZIG_DIR "${CMAKE_BINARY_DIR}/zig-relsafe-${ZIG_TRIPLET}")
set(ZIG_ARCHIVE "${ZIG_DIR}.${ARCHIVE_EXT}")

# ─── Decide which zig to use ─────────────────────────────────────────────────
find_program(ZIG_FOUND zig)

set(USE_ZIG_ESPRESSIF_BOOTSTRAP TRUE)
if(ZIG_FOUND AND CONFIG_IDF_TARGET_ARCH_RISCV)
    # For most RISC-V prefer system zig (except P4 & H4)
    # FIXME: https://github.com/kassane/zig-esp-idf-sample/issues/45 (upstream - no fixed)
    if(NOT (CONFIG_IDF_TARGET_ESP32P4 OR CONFIG_IDF_TARGET_ESP32H4 OR CONFIG_IDF_TARGET_ESP32C5 OR CONFIG_IDF_TARGET_ESP32C61))
        set(USE_ZIG_ESPRESSIF_BOOTSTRAP FALSE)
    endif()
endif()

# ─── Download & extract espressif zig if needed ──────────────────────────────
if(USE_ZIG_ESPRESSIF_BOOTSTRAP)
    include(${CMAKE_SOURCE_DIR}/cmake/zig-download.cmake)
else()
    if(NOT ZIG_FOUND)
        message(FATAL_ERROR "System 'zig' not found and espressif bootstrap is disabled.")
    endif()
    set(ZIG_BIN "${ZIG_FOUND}")
endif()
message(STATUS "Using Zig executable: ${ZIG_BIN}")

# ────────────────────────────────────────────────────────────────────────────────────
include(${CMAKE_SOURCE_DIR}/cmake/zig-runner.cmake)
# ─────── get Zig version ────────────────────────────────────────────────────────────
zig_run(COMMAND version OUTPUT_VARIABLE ZIG_VERSION)
if("${ZIG_VERSION}" VERSION_LESS "${ZIG_MIN_VERSION}")
    message(FATAL_ERROR "Zig version too old: ${ZIG_VERSION} < ${ZIG_MIN_VERSION}")
endif()
message(STATUS "Zig version: ${ZIG_VERSION}")

# ====================================================================================

# Determine target model from CONFIG_IDF_TARGET
string(TOLOWER "${CONFIG_IDF_TARGET}" TARGET_IDF_MODEL)

# Target architecture configuration lookup table
set(RISCV_TARGETS
    "esp32c2" "esp32c3" "esp32c5" "esp32c6" "esp32c61" "esp32h2" "esp32h21" "esp32h4" "esp32p4")
set(XTENSA_TARGETS
    "esp32" "esp32s2" "esp32s3")

if(TARGET_IDF_MODEL IN_LIST RISCV_TARGETS)
    set(TARGET_IDF_ARCH "riscv")
    set(ZIG_TARGET "riscv32-freestanding-none")

    # Determine CPU model based on target
    set(RV_IMAC_TARGETS "esp32c6" "esp32c5" "esp32c61" "esp32h2" "esp32h21")
    if(TARGET_IDF_MODEL IN_LIST RV_IMAC_TARGETS)
        set(TARGET_CPU_MODEL "generic_rv32+m+a+c+zicsr+zifencei")
    elseif(TARGET_IDF_MODEL STREQUAL "esp32p4")
        set(ZIG_TARGET "riscv32-freestanding-eabihf")
        # (zca, zcb, zcmt, zcmp) are not supported on ESP32-P4-Function-EV-Board (crashes application)
        set(TARGET_CPU_MODEL "esp32p4-zca-zcb-zcmt-zcmp")
    elseif(TARGET_IDF_MODEL STREQUAL "esp32h4")
        set(ZIG_TARGET "riscv32-freestanding-eabihf")
        set(TARGET_CPU_MODEL "esp32h4")
    else()
        # ESP32-C2/C3 and fallback
        set(TARGET_CPU_MODEL "generic_rv32+m+c+zicsr+zifencei")
    endif()

elseif(TARGET_IDF_MODEL IN_LIST XTENSA_TARGETS)
    set(TARGET_IDF_ARCH "xtensa")
    set(ZIG_TARGET "xtensa-freestanding-none")
    set(TARGET_CPU_MODEL "${TARGET_IDF_MODEL}")

else()
    message(FATAL_ERROR "Unsupported IDF target: ${CONFIG_IDF_TARGET}")
endif()

message(STATUS "ESP-IDF Target: ${TARGET_IDF_MODEL}")
message(STATUS "Architecture: ${TARGET_IDF_ARCH}")
message(STATUS "Zig Target: ${ZIG_TARGET}")
message(STATUS "CPU Model: ${TARGET_CPU_MODEL}")

# Check Toolchain version
get_filename_component(TOOLCHAIN_BIN_DIR "${CMAKE_C_COMPILER}" DIRECTORY)
get_filename_component(TOOLCHAIN_VERSION_DIR "${TOOLCHAIN_BIN_DIR}" DIRECTORY)
if("${TOOLCHAIN_VERSION_DIR}" MATCHES "esp-([0-9]+\\.[0-9]+\\.[0-9]+_[0-9]+)")
    set(TOOLCHAIN_VERSION "${CMAKE_MATCH_1}")
    message(STATUS "Detected ESP toolchain version: ${TOOLCHAIN_VERSION}")
else()
    message(WARNING "Standard ESP version pattern not found in: ${TOOLCHAIN_VERSION_DIR}")
endif()

if(CONFIG_IDF_TARGET_ARCH_RISCV)
    set(ARCH "riscv")
    set(TRIPLE "riscv32-esp-elf")
    set(ARCH_DEFINE "__riscv")
elseif(CONFIG_IDF_TARGET_ARCH_XTENSA)
    set(ARCH "xtensa")
    set(TRIPLE "xtensa-esp-elf")
    set(ARCH_DEFINE "__XTENSA__")
endif()
# Get toolchain includes with fallback paths
set(POSSIBLE_INCLUDE_PATHS
    "${TOOLCHAIN_VERSION_DIR}/${TRIPLE}/include"
    "${TOOLCHAIN_BIN_DIR}/../${TRIPLE}/include"
    "${TOOLCHAIN_VERSION_DIR}/${TRIPLE}/${TRIPLE}/include"
)
# Find the toolchain include directory
set(TOOLCHAIN_ELF_INCLUDE "")
foreach(PATH ${POSSIBLE_INCLUDE_PATHS})
    if(IS_DIRECTORY "${PATH}")
        set(TOOLCHAIN_ELF_INCLUDE "${PATH}")
        message(STATUS "Found toolchain include at: ${TOOLCHAIN_ELF_INCLUDE}")
        break()
    endif()
endforeach()
# sys-include should be sys-include directory OR the same as regular include
# (since sys headers are typically under include/sys/)
set(POSSIBLE_SYS_INCLUDE_PATHS
    "${TOOLCHAIN_VERSION_DIR}/${TRIPLE}/sys-include"
    "${TOOLCHAIN_BIN_DIR}/../${TRIPLE}/sys-include"
    "${TOOLCHAIN_VERSION_DIR}/${TRIPLE}/${TRIPLE}/sys-include"
    "${TOOLCHAIN_ELF_INCLUDE}"
)
# Find the first existing sys-include directory
set(TOOLCHAIN_SYS_INCLUDE "")
foreach(PATH ${POSSIBLE_SYS_INCLUDE_PATHS})
    if(IS_DIRECTORY "${PATH}")
        set(TOOLCHAIN_SYS_INCLUDE "${PATH}")
        message(STATUS "Found sys-include at: ${TOOLCHAIN_SYS_INCLUDE}")
        break()
    endif()
endforeach()
if(NOT IS_DIRECTORY "${TOOLCHAIN_ELF_INCLUDE}")
    message(WARNING "Toolchain include directory not found: ${TOOLCHAIN_ELF_INCLUDE}")
endif()
if(NOT IS_DIRECTORY "${TOOLCHAIN_SYS_INCLUDE}")
    message(WARNING "Toolchain sys-include directory not found: ${TOOLCHAIN_SYS_INCLUDE}")
endif()

# components list
set(INCLUDE_DIRS
    "${IDF_PATH}/components/freertos/FreeRTOS-Kernel-SMP/portable/${ARCH}/include"
    "${IDF_PATH}/components/freertos/FreeRTOS-Kernel-SMP/portable/${ARCH}/include/freertos"
    "${IDF_PATH}/components/freertos/FreeRTOS-Kernel/include"
    "${IDF_PATH}/components/freertos/config/include"
    "${IDF_PATH}/components/freertos/config/include/freertos"
    "${IDF_PATH}/components/freertos/esp_additions/include"
    "${IDF_PATH}/components/freertos/config/${ARCH}/include"
    "${IDF_PATH}/components/esp_hw_support/include"
    "${IDF_PATH}/components/soc/include"
    "${IDF_PATH}/components/soc/${TARGET_IDF_MODEL}/include"
    "${IDF_PATH}/components/esp_common/include"
    "${IDF_PATH}/components/hal/include"
    "${IDF_PATH}/components/${ARCH}/include"
    "${IDF_PATH}/components/bt/include/${TARGET_IDF_MODEL}/include"
    "${IDF_PATH}/components/bt/host/nimble/nimble/nimble/include"
    "${IDF_PATH}/components/bt/host/bluedroid/api/include"
    "${IDF_PATH}/components/bt/host/bluedroid/api/include/api"
    "${IDF_PATH}/components/${ARCH}/${TARGET_IDF_MODEL}/include"
    "${IDF_PATH}/components/${ARCH}/${TARGET_IDF_MODEL}/include/${ARCH}"
    "${IDF_PATH}/components/${ARCH}/${TARGET_IDF_MODEL}/include/${ARCH}/config"
    "${IDF_PATH}/components/${ARCH}/${TARGET_IDF_MODEL}/include/${ARCH}/core"
    "${IDF_PATH}/components/soc/${TARGET_IDF_MODEL}/register"
    "${IDF_PATH}/components/esp_system/include"
    "${IDF_PATH}/components/esp_hw_support/etm/include"
    "${IDF_PATH}/components/esp_hw_support/ldo/include"
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
    "${IDF_PATH}/components/esp_driver_ana_cmpr/include"
    "${IDF_PATH}/components/esp_driver_bitscrambler/include"
    "${IDF_PATH}/components/esp_driver_cam/include"
    "${IDF_PATH}/components/esp_driver_dac/include"
    "${IDF_PATH}/components/esp_driver_gpio/include"
    "${IDF_PATH}/components/esp_driver_gptimer/include"
    "${IDF_PATH}/components/esp_driver_i2c/include"
    "${IDF_PATH}/components/esp_driver_i2s/include"
    "${IDF_PATH}/components/esp_driver_i3c/include"
    "${IDF_PATH}/components/esp_driver_isp/include"
    "${IDF_PATH}/components/esp_driver_jpeg/include"
    "${IDF_PATH}/components/esp_driver_ledc/include"
    "${IDF_PATH}/components/esp_driver_mcpwm/include"
    "${IDF_PATH}/components/esp_driver_parlio/include"
    "${IDF_PATH}/components/esp_driver_pcnt/include"
    "${IDF_PATH}/components/esp_driver_ppa/include"
    "${IDF_PATH}/components/esp_driver_rmt/include"
    "${IDF_PATH}/components/esp_driver_sd_intf/include"
    "${IDF_PATH}/components/esp_driver_sdio/include"
    "${IDF_PATH}/components/esp_driver_sdm/include"
    "${IDF_PATH}/components/esp_driver_sdmmc/include"
    "${IDF_PATH}/components/esp_driver_sdspi/include"
    "${IDF_PATH}/components/esp_driver_spi/include"
    "${IDF_PATH}/components/esp_driver_touch_sens/include"
    "${IDF_PATH}/components/esp_driver_tsens/include"
    "${IDF_PATH}/components/esp_driver_twai/include"
    "${IDF_PATH}/components/esp_driver_uart/include"
    "${IDF_PATH}/components/esp_driver_usb_serial_jtag/include"
    "${IDF_PATH}/components/esp_phy/include"
    "${IDF_PATH}/components/esp_tee/include"
    "${IDF_PATH}/components/esp_timer/include"
    "${IDF_PATH}/components/esp_coex/include"
    "${IDF_PATH}/components/esp_psram/include"
    "${IDF_PATH}/components/esp_security/include"
    "${IDF_PATH}/components/esp_trace/include"
    "${IDF_PATH}/components/esp_blockdev/include"
    "${IDF_PATH}/components/hal/platform_port/include"
    "${IDF_PATH}/components/heap/include"
    "${IDF_PATH}/components/ieee802154/include"
    "${IDF_PATH}/components/openthread/include"
    "${IDF_PATH}/components/esp_rom/include"
    "${IDF_PATH}/components/esp_wifi/include"
    "${IDF_PATH}/components/esp_event/include"
    "${IDF_PATH}/components/lwip/include"
    "${IDF_PATH}/components/lwip/lwip/src/include"
    "${IDF_PATH}/components/lwip/port/include"
    "${IDF_PATH}/components/lwip/port/freertos/include"
    "${IDF_PATH}/components/lwip/port/esp32xx/include"
    "${IDF_PATH}/components/log/include"
    "${IDF_PATH}/components/vfs/include"
    "${IDF_PATH}/components/wpa_supplicant/esp_supplicant/include"
    "${IDF_PATH}/components/nvs_flash/include"
    "${IDF_PATH}/components/esp_partition/include"
    "${IDF_PATH}/components/esp_netif/include"
    "${IDF_PATH}/components/esp_event/include"
    "${IDF_PATH}/components/driver/i2c/include"
    "${IDF_PATH}/components/driver/deprecated"
    "${IDF_PATH}/components/driver/touch_sensor/${TARGET_IDF_MODEL}/include"
    "${IDF_PATH}/components/driver/touch_sensor/include"
    "${IDF_PATH}/components/driver/twai/include"
    "${IDF_PATH}/components/spi_flash/include"
    "${IDF_PATH}/components/esp_usb_cdc_rom_console/include"
    "${CMAKE_SOURCE_DIR}/build/config"
)
# Toolchain system includes (separate from regular includes)
set(SYSTEM_INCLUDE_DIRS
    "${TOOLCHAIN_SYS_INCLUDE}"
    "${TOOLCHAIN_ELF_INCLUDE}"
    "${IDF_PATH}/components/newlib"
    "${IDF_PATH}/components/newlib/platform_include"
    "${IDF_PATH}/components/esp_libc/platform_include"
)
if(CONFIG_IDF_TARGET_ESP32P4)
    list(APPEND INCLUDE_DIRS "${IDF_PATH}/components/soc/${TARGET_IDF_MODEL}/register/hw_ver3")
elseif(CONFIG_IDF_TARGET_ESP32H4)
    list(APPEND INCLUDE_DIRS "${IDF_PATH}/components/soc/${TARGET_IDF_MODEL}/register/hw_ver_mp")
endif()

# get esp-idf C Macros
idf_build_get_property(all_defines COMPILE_DEFINITIONS)

set(EXTRA_DEFINE_FLAGS "")
foreach(def ${all_defines})
    string(STRIP "${def}" def_clean)
    if(NOT def_clean STREQUAL "")
        if(NOT def_clean MATCHES "^-D")
            list(APPEND EXTRA_DEFINE_FLAGS "-D${def_clean}")
        else()
            list(APPEND EXTRA_DEFINE_FLAGS "${def_clean}")
        endif()
    endif()
endforeach()

list(APPEND EXTRA_DEFINE_FLAGS
    "-fno-builtin"
    "-D__GNUC__"
)

string(TOUPPER "${TARGET_IDF_ARCH}" TARGET_IDF_ARCH_UPPER)
string(TOUPPER "${TARGET_IDF_MODEL}" TARGET_IDF_MODEL_UPPER)
set(DEFINE_FLAGS
    "-D__${TARGET_IDF_ARCH}"
    "-Dcpu_${TARGET_CPU_MODEL}"
    "-D${ARCH_DEFINE}"
    "-D__${TARGET_IDF_ARCH_UPPER}_EL__"
    "-DCONFIG_IDF_TARGET_${TARGET_IDF_MODEL_UPPER}"
    "-D__COUNTER__=0"
    "-DIRAM_ATTR="
    "-D_SECTION_ATTR_IMPL\\(x,y\\)="
    "-DSOC_MMU_PAGE_SIZE=0x8000"
    "-DLWIP_NO_UNISTD_H="
)
string(JOIN " " DEFINE_FLAGS_STR ${DEFINE_FLAGS})

if(ARCH_DEFINE)
    set(DEFINE_FLAGS "${DEFINE_FLAGS} -D${ARCH_DEFINE}")
endif()
set(IDF_SYS_ZIG "${CMAKE_SOURCE_DIR}/imports/idf-sys.zig")
set(IDF_SYS_C "${CMAKE_SOURCE_DIR}/include/stubs.h")

# get esp-rs bindings.h
include(${CMAKE_SOURCE_DIR}/cmake/bindings.cmake)

# add extra-components
include(${CMAKE_SOURCE_DIR}/cmake/extra-components.cmake)

set(INCLUDE_FLAGS "")
foreach(dir ${INCLUDE_DIRS})
    set(INCLUDE_FLAGS "${INCLUDE_FLAGS} -I\"${dir}\"")
endforeach()

# Build system include flags (for toolchain)
foreach(dir ${SYSTEM_INCLUDE_DIRS})
    set(INCLUDE_FLAGS "${INCLUDE_FLAGS} -isystem \"${dir}\"")
endforeach()
if(NOT WIN32)
    separate_arguments(INCLUDE_FLAGS UNIX_COMMAND "${INCLUDE_FLAGS}")
else()
    separate_arguments(INCLUDE_FLAGS WINDOWS_COMMAND "${INCLUDE_FLAGS}")
endif()

# Run `translate-c` to generate `idf-sys.zig`
zig_run(
    COMMAND translate-c
    -target ${ZIG_TARGET} -mcpu ${TARGET_CPU_MODEL}
    ${DEFINE_FLAGS} ${EXTRA_DEFINE_FLAGS} ${INCLUDE_FLAGS} ${IDF_SYS_C}
    OUTPUT_FILE ${IDF_SYS_ZIG}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
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
    COMMAND ${CMAKE_COMMAND} -D TARGET_FILE="${IDF_SYS_ZIG}"
    -D CONFIG_IDF_TARGET_ESP32H2="${CONFIG_IDF_TARGET_ESP32H2}"
    -D CONFIG_IDF_TARGET_ESP32H4="${CONFIG_IDF_TARGET_ESP32H4}"
    -D CONFIG_IDF_TARGET_ESP32P4="${CONFIG_IDF_TARGET_ESP32P4}"
    -P ${CMAKE_SOURCE_DIR}/cmake/patch.cmake
    COMMAND ${CMAKE_COMMAND} -E touch "${CMAKE_BINARY_DIR}/patches_applied.done"
)


if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(ZIG_BUILD_TYPE "Debug")
else()
    set(ZIG_BUILD_TYPE "ReleaseSafe")
endif()

add_custom_target(zig_build
    ${ZIG_BIN} build
    --build-file ${CMAKE_SOURCE_DIR}/build.zig
    -Doptimize=${ZIG_BUILD_TYPE}
    -Dtarget=${ZIG_TARGET}
    -Dcpu=${TARGET_CPU_MODEL}
    -freference-trace
    --cache-dir ${CMAKE_BINARY_DIR}/../.zig-cache
    --prefix ${CMAKE_BINARY_DIR}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    BYPRODUCTS ${CMAKE_BINARY_DIR}/obj/app_zig.o
    VERBATIM)

add_dependencies(zig_build translate_c)
add_dependencies(${COMPONENT_LIB} zig_build)

target_sources(${COMPONENT_LIB}
    PRIVATE
    ${CMAKE_BINARY_DIR}/obj/app_zig.o
)
