cmake_minimum_required(VERSION 3.12)

message(STATUS "Patching TARGET_FILE: ${TARGET_FILE}")

# Read the file content
file(READ "${TARGET_FILE}" FILE_CONTENT)

# Apply Replacements
string(REGEX REPLACE "pub const wifi_sta_config_t[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")
string(REGEX REPLACE "pub const portTICK_PERIOD_MS[^;]*;" "" FILE_CONTENT "${FILE_CONTENT}")

# Append patches
set(PATCH_DIR "${CMAKE_SOURCE_DIR}/../../../patches")

foreach(PATCH_FILE "wifi_sta_config_t.zig" "porttick_period_ms.zig")
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
