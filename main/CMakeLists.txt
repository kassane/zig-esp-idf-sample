set(DEPS nvs_flash)
if(CONFIG_ESP_WIFI_ENABLED)
    list(APPEND DEPS esp_wifi esp_netif esp_event)
endif()
if(CONFIG_BT_ENABLED)
    list(APPEND DEPS bt)
endif()

set(MAIN_SRCS "placeholder.c")

# Add C++ Matter wrapper shim only when esp_matter is an active build component.
# The component must be added via idf.py add-dependency espressif/esp_matter.
# Note: esp_matter 1.4.x is not yet compatible with IDF v6.0 (requires json/mqtt builtins).
if(TARGET __idf_espressif__esp_matter AND IDF_VERSION_MAJOR LESS 6)
    list(APPEND MAIN_SRCS "matter_wrappers.cpp")
    list(APPEND DEPS espressif__esp_matter)
    message(STATUS "ESP Matter: C++ wrapper shim enabled")
endif()

idf_component_register(
    SRCS ${MAIN_SRCS}
    INCLUDE_DIRS "." "${CMAKE_SOURCE_DIR}/include"
    REQUIRES ${DEPS}
)

# Build your project or examples

set(ZIG_EXAMPLE_ARG "") # default is main/app.zig

if(CONFIG_ZIG_EXAMPLE_SMARTLED_RGB)
    set(ZIG_ROOT_EXAMPLE_SOURCE "main/examples/smartled-rgb.zig")
    set(ZIG_EXAMPLE_ARG "-Dexample=${ZIG_ROOT_EXAMPLE_SOURCE}")
elseif(CONFIG_ZIG_EXAMPLE_WIFI_STATION AND CONFIG_ESP_WIFI_ENABLED)
    set(ZIG_ROOT_EXAMPLE_SOURCE "main/examples/wifi-station.zig")
    set(ZIG_EXAMPLE_ARG "-Dexample=${ZIG_ROOT_EXAMPLE_SOURCE}")
elseif(CONFIG_ZIG_EXAMPLE_DSP_MATH)
    set(ZIG_ROOT_EXAMPLE_SOURCE "main/examples/dsp-math.zig")
    set(ZIG_EXAMPLE_ARG "-Dexample=${ZIG_ROOT_EXAMPLE_SOURCE}")
elseif(CONFIG_ZIG_EXAMPLE_GPIO_BLINK)
    set(ZIG_ROOT_EXAMPLE_SOURCE "main/examples/gpio-blink.zig")
    set(ZIG_EXAMPLE_ARG "-Dexample=${ZIG_ROOT_EXAMPLE_SOURCE}")
elseif(CONFIG_ZIG_EXAMPLE_HTTP_SERVER)
    set(ZIG_ROOT_EXAMPLE_SOURCE "main/examples/http-server.zig")
    set(ZIG_EXAMPLE_ARG "-Dexample=${ZIG_ROOT_EXAMPLE_SOURCE}")
elseif(CONFIG_ZIG_EXAMPLE_BLE_GATT_SERVER AND CONFIG_BT_ENABLED)
    set(ZIG_ROOT_EXAMPLE_SOURCE "main/examples/ble-gatt-server.zig")
    set(ZIG_EXAMPLE_ARG "-Dexample=${ZIG_ROOT_EXAMPLE_SOURCE}")
elseif(CONFIG_ZIG_EXAMPLE_I2C_SCAN)
    set(ZIG_ROOT_EXAMPLE_SOURCE "main/examples/i2c-scan.zig")
    set(ZIG_EXAMPLE_ARG "-Dexample=${ZIG_ROOT_EXAMPLE_SOURCE}")
elseif(CONFIG_ZIG_EXAMPLE_UART_ECHO)
    set(ZIG_ROOT_EXAMPLE_SOURCE "main/examples/uart-echo.zig")
    set(ZIG_EXAMPLE_ARG "-Dexample=${ZIG_ROOT_EXAMPLE_SOURCE}")
elseif(CONFIG_ZIG_EXAMPLE_MATTER_LIGHT)
    set(ZIG_ROOT_EXAMPLE_SOURCE "main/examples/matter-light.zig")
    set(ZIG_EXAMPLE_ARG "-Dexample=${ZIG_ROOT_EXAMPLE_SOURCE}")
endif()

if(ZIG_EXAMPLE_ARG)
    message(STATUS "Zig Example: ${ZIG_ROOT_EXAMPLE_SOURCE}")
else()
    message(STATUS "Zig Example: using default (main/app.zig)")
endif()

include(${CMAKE_SOURCE_DIR}/cmake/zig-config.cmake)

# FIXME: need add <cmath> for build kalman
if(TARGET __idf_espressif__esp-dsp AND IDF_VERSION_MAJOR EQUAL 6)
    target_compile_options(__idf_espressif__esp-dsp PRIVATE
        $<$<COMPILE_LANGUAGE:CXX>:-includecmath>
    )
endif()

# CHIP SDK: suppress -Werror=format-nonliteral warnings-as-errors that GCC 14
# raises on format strings forwarded through function pointers (BLEManagerImpl etc.).
if(TARGET __idf_espressif__esp_matter AND IDF_VERSION_MAJOR LESS 6)
    target_compile_options(__idf_espressif__esp_matter PRIVATE
        $<$<COMPILE_LANGUAGE:CXX>:-Wno-error=format-nonliteral>
    )
endif()

# CHIP SDK closure-control cluster structs are missing operator==(const T&), which
# GCC 14 C++23 mode rejects when used in std::optional comparisons.
# Inject a patch header via -include on only the two failing translation units so
# that the types satisfy std::equality_comparable without touching managed_components.
if(TARGET __idf_espressif__esp_matter AND IDF_VERSION_MAJOR LESS 6)
    set(_CHIP_CLOSURE_DIR
        "${CMAKE_SOURCE_DIR}/managed_components/espressif__esp_matter/connectedhomeip/connectedhomeip/src/app/clusters/closure-control-server"
    )
    set_source_files_properties(
        "${_CHIP_CLOSURE_DIR}/closure-control-cluster-logic.cpp"
        "${_CHIP_CLOSURE_DIR}/closure-control-server.cpp"
        DIRECTORY "${CMAKE_SOURCE_DIR}/managed_components/espressif__esp_matter"
        PROPERTIES COMPILE_FLAGS
        "-include${CMAKE_SOURCE_DIR}/include/matter_closure_patch.h"
    )
    unset(_CHIP_CLOSURE_DIR)
endif()
