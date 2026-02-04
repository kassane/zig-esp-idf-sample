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
# Remove problematic definitions
# These structs/functions are removed because they need custom implementations
# ============================================================================

# Remove wifi_sta_config_t (will be replaced with custom version)
string(REGEX REPLACE "pub const wifi_sta_config_t[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")
# Remove wifi_ap_config_t (will be replaced with custom version)
string(REGEX REPLACE "pub const wifi_ap_config_t[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")
# Remove portTICK_PERIOD_MS (will be replaced with custom version)
string(REGEX REPLACE "pub const portTICK_PERIOD_MS[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")
# ESP32-P4 specific: Remove xPortCanYield function
if(CONFIG_IDF_TARGET_ESP32P4)
    string(REGEX REPLACE "pub fn xPortCanYield\\([^)]*\\) callconv\\(\\.c\\) bool \\{([^{}]|\\{[^{}]*\\})*\\}" "" FILE_CONTENT "${FILE_CONTENT}")
endif()

# ============================================================================
# Append custom patch files
# These files contain the corrected implementations
# ============================================================================
set(PATCH_DIR "${CMAKE_SOURCE_DIR}/../../../patches")

# Define patches to apply
set(PATCH_FILES
    "wifi_sta_config_t.zig" # WiFi station configuration
    "wifi_ap_config_t.zig" # WiFi access point configuration
    "porttick_period_ms.zig" # FreeRTOS tick period
)
# Add target-specific patches
if(CONFIG_IDF_TARGET_ESP32P4)
    list(APPEND PATCH_FILES "xport_can_yield.zig") # ESP32-P4 yield function
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
