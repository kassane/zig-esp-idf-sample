cmake_minimum_required(VERSION 3.12)

message(STATUS "Patching TARGET_FILE: ${TARGET_FILE}")

# Read the file content
file(READ "${TARGET_FILE}" FILE_CONTENT)

# Apply Replacements
string(REGEX REPLACE "pub const wifi_sta_config_t[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")
string(REGEX REPLACE "pub const portTICK_PERIOD_MS[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")

if (CONFIG_IDF_TARGET_ESP32P4)
    string(REGEX REPLACE "pub fn xPortCanYield\\([^)]*\\) callconv\\(\\.c\\) bool \\{([^{}]|\\{[^{}]*\\})*\\}" "" FILE_CONTENT "${FILE_CONTENT}")
endif()

# Append patches
set(PATCH_DIR "${CMAKE_SOURCE_DIR}/../../../patches")
set(PATCH_FILES "wifi_sta_config_t.zig" "porttick_period_ms.zig")

if (CONFIG_IDF_TARGET_ESP32P4)
    list(APPEND PATCH_FILES "xport_can_yield.zig")
endif()

foreach(PATCH_FILE IN LISTS PATCH_FILES)
    set(PATCH_PATH "${PATCH_DIR}/${PATCH_FILE}")
    if (EXISTS "${PATCH_PATH}")
        message(STATUS "Appending patch: ${PATCH_PATH}")
        file(READ "${PATCH_PATH}" PATCH_CONTENT)
        set(FILE_CONTENT "${FILE_CONTENT}\n${PATCH_CONTENT}")
    else()
        message(WARNING "Patch file does not exist: ${PATCH_PATH}")
    endif()
endforeach()

# Write modified content back to the file
file(WRITE "${TARGET_FILE}" "${FILE_CONTENT}")

message(STATUS "Successfully patched TARGET_FILE: ${TARGET_FILE}")
