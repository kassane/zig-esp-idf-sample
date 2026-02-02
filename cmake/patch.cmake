cmake_minimum_required(VERSION 3.12)

message(STATUS "Patching TARGET_FILE: ${TARGET_FILE}")

# Read the file content
file(READ "${TARGET_FILE}" FILE_CONTENT)

# Apply Replacements
string(REGEX REPLACE "pub const wifi_sta_config_t[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")
string(REGEX REPLACE "pub const wifi_ap_config_t[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")
string(REGEX REPLACE "pub const portTICK_PERIOD_MS[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")

if(CONFIG_IDF_TARGET_ESP32P4)
    string(REGEX REPLACE "pub fn xPortCanYield\\([^)]*\\) callconv\\(\\.c\\) bool \\{([^{}]|\\{[^{}]*\\})*\\}" "" FILE_CONTENT "${FILE_CONTENT}")
endif()

# Find all potential enum blocks
string(REGEX MATCHALL "(pub const [A-Z_]+ = [0-9]+;\n)+pub const ([a-z_]+_t) = c_uint;" ENUM_BLOCKS "${FILE_CONTENT}")

foreach(BLOCK ${ENUM_BLOCKS})
    # Extract the enum type name (e.g. wifi_scan_method_t)
    string(REGEX MATCH "pub const ([a-z_]+_t) = c_uint;" _ ENUM_TYPE "${BLOCK}")
    set(ENUM_TYPE ${CMAKE_MATCH_1})

    # Remove the original block (constants + typedef)
    string(REGEX REPLACE "${BLOCK}" "" FILE_CONTENT "${FILE_CONTENT}")

    # Build the new enum
    set(NEW_ENUM "pub const ${ENUM_TYPE} = enum(c_uint) {\n")
    string(REGEX MATCHALL "pub const ([A-Z_]+) = ([0-9]+);" CONSTANTS "${BLOCK}")
    foreach(CONST ${CONSTANTS})
        string(REGEX MATCH "pub const ([A-Z_]+) = ([0-9]+);" _ NAME VALUE "${CONST}")
        set(NEW_ENUM "${NEW_ENUM}    ${NAME} = ${VALUE},\n")
    endforeach()
    set(NEW_ENUM "${NEW_ENUM}};\n")

    # Append the new enum (you can adjust position if needed)
    set(FILE_CONTENT "${FILE_CONTENT}\n${NEW_ENUM}")
    message(STATUS "Converted enum: ${ENUM_TYPE}")
endforeach()

# Append patches
set(PATCH_DIR "${CMAKE_SOURCE_DIR}/../../../patches")
set(PATCH_FILES "wifi_sta_config_t.zig" "wifi_ap_config_t.zig" "porttick_period_ms.zig")

if(CONFIG_IDF_TARGET_ESP32P4)
    list(APPEND PATCH_FILES "xport_can_yield.zig")
endif()

foreach(PATCH_FILE IN LISTS PATCH_FILES)
    set(PATCH_PATH "${PATCH_DIR}/${PATCH_FILE}")
    if(EXISTS "${PATCH_PATH}")
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
