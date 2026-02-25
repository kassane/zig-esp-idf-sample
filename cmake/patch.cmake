# ============================================================================
# Zig Bindings Patcher
# Removes and replaces problematic structs/functions from ESP-IDF bindings
# ============================================================================

message(STATUS "Patching Zig bindings: ${TARGET_FILE}")

# ============================================================================
# Read file content
# ============================================================================
file(READ "${TARGET_FILE}" FILE_CONTENT)

# ============================================================================
# Determine WiFi support based on target
# ============================================================================
if(CONFIG_IDF_TARGET_ESP32P4 OR CONFIG_IDF_TARGET_ESP32H2 OR CONFIG_IDF_TARGET_ESP32H21 OR CONFIG_IDF_TARGET_ESP32H4)
    set(WIFI_SUPPORTED FALSE)
else()
    set(WIFI_SUPPORTED TRUE)
endif()

# ============================================================================
# Component status (passed from zig-config.cmake)
# ============================================================================
if(NOT DEFINED HAS_LED_STRIP)
    set(HAS_LED_STRIP 0)
endif()
if(NOT DEFINED HAS_ESP_DSP)
    set(HAS_ESP_DSP 0)
endif()

# message(STATUS "Component detection:")
# message(STATUS "  HAS_LED_STRIP: ${HAS_LED_STRIP}")
# message(STATUS "  HAS_ESP_DSP: ${HAS_ESP_DSP}")

# ============================================================================
# Remove problematic definitions
# ============================================================================

# WiFi patches (only for WiFi-enabled targets)
if(WIFI_SUPPORTED)
    string(REGEX REPLACE "pub const wifi_sta_config_t[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")
    string(REGEX REPLACE "pub const wifi_ap_config_t[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")
endif()

# Remove portTICK_PERIOD_MS (will be replaced with custom version)
string(REGEX REPLACE "pub const portTICK_PERIOD_MS[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")

# ============================================================================
# Handle bitfield-related opaque types and unions
# ============================================================================
string(REGEX REPLACE "(//[^\n]*\n?)*const struct_unnamed_[0-9]+ = opaque {};( //[^\n]*\n?)*" "" FILE_CONTENT "${FILE_CONTENT}")
string(REGEX REPLACE "(//[^\n]*\n?)*const union_unnamed_[0-9]+ = extern union \\{\n    unnamed_0: struct_unnamed_[0-9]+,\n    val: u32,\n\\};( //[^\n]*\n?)*" "" FILE_CONTENT "${FILE_CONTENT}")
string(REGEX REPLACE "unnamed_0: struct_unnamed_[0-9]+,\n?" "" FILE_CONTENT "${FILE_CONTENT}")
string(REGEX REPLACE "([a-zA-Z0-9_]+): ((\[[0-9]+\])?)(struct|union)_unnamed_[0-9]+" "\\1: \\2u32" FILE_CONTENT "${FILE_CONTENT}")
string(REGEX REPLACE "zeroes\\((struct|union)_unnamed_[0-9]+\\)" "zeroes(u32)" FILE_CONTENT "${FILE_CONTENT}")
string(REGEX REPLACE "zeroes\\((\\[[0-9]+\\])(struct|union)_unnamed_[0-9]+\\)" "zeroes(\\1u32)" FILE_CONTENT "${FILE_CONTENT}")

# ESP32-P4 specific: Remove xPortCanYield function
if(CONFIG_IDF_TARGET_ESP32P4)
    string(REGEX REPLACE "pub fn xPortCanYield\\([^)]*\\) callconv\\(\\.c\\) bool \\{([^{}]|\\{[^{}]*\\})*\\}" "" FILE_CONTENT "${FILE_CONTENT}")
endif()

# LED Strip component patches (if enabled)
if(HAS_LED_STRIP EQUAL 1)
    message(STATUS "  Applying LED Strip patches")
    string(REGEX REPLACE "pub const struct_led_strip_rmt_extra_config_20[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")
    string(REGEX REPLACE "pub const struct_format_layout_15[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")
    string(REGEX REPLACE "pub const led_strip_rmt_config_t[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")
    string(REGEX REPLACE "pub const led_color_component_format_t[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")
    string(REGEX REPLACE "pub const led_strip_config_t = extern struct \\{[^}]*\\};" "" FILE_CONTENT "${FILE_CONTENT}")
endif()

# ============================================================================
# Append custom patch files
# ============================================================================
set(PATCH_DIR "${CMAKE_SOURCE_DIR}/../../../patches")

# Define patches to apply
set(PATCH_FILES
    "porttick_period_ms.zig"
)

# Add target-specific patches
if(CONFIG_IDF_TARGET_ESP32P4)
    list(APPEND PATCH_FILES "xport_can_yield.zig")
endif()

# Add WiFi patches
if(WIFI_SUPPORTED)
    list(APPEND PATCH_FILES
        "wifi/wifi_sta_config_t.zig"
        "wifi/wifi_ap_config_t.zig"
    )
endif()

# Add LED Strip patches
if(HAS_LED_STRIP EQUAL 1)
    list(APPEND PATCH_FILES
        "led_strip/led_strip_rmt_extra_config_20.zig"
        "led_strip/led_strip_struct_format_layout_15.zig"
        "led_strip/led_color_component_format_t.zig"
        "led_strip/led_strip_rmt_config_t.zig"
        "led_strip/led_strip_config_t.zig"
    )
endif()

# Apply each patch file
foreach(PATCH_FILE IN LISTS PATCH_FILES)
    set(PATCH_PATH "${PATCH_DIR}/${PATCH_FILE}")
    if(EXISTS "${PATCH_PATH}")
        message(STATUS "  Applying patch: ${PATCH_FILE}")
        file(READ "${PATCH_PATH}" PATCH_CONTENT)
        string(APPEND FILE_CONTENT "\n${PATCH_CONTENT}")
    else()
        message(WARNING "  Patch file not found: ${PATCH_FILE}")
    endif()
endforeach()

# ============================================================================
# Write patched content
# ============================================================================
file(WRITE "${TARGET_FILE}" "${FILE_CONTENT}")
message(STATUS "Patching completed: ${TARGET_FILE}")
