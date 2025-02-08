cmake_minimum_required(VERSION 3.12)

set(TARGET_FILE "@TARGET_FILE@")
set(SEARCH_STRING "@SEARCH_STRING@")
set(REPLACE_STRING "@REPLACE_STRING@")
set(APPEND_FILE "@APPEND_FILE@")

message(STATUS "Reading to TARGET_FILE: ${TARGET_FILE}")

# Read the file content
file(READ "${TARGET_FILE}" FILE_CONTENT)

# Replace occurrences of SEARCH_STRING with REPLACE_STRING
string(REPLACE "${SEARCH_STRING}" "${REPLACE_STRING}" NEW_CONTENT "${FILE_CONTENT}")

# Append new content if APPEND_FILE is provided
if (NOT "${APPEND_FILE}" STREQUAL "")
    file(READ "${APPEND_FILE}" APPEND_CONTENT)
    set(NEW_CONTENT "${NEW_CONTENT}\n${APPEND_CONTENT}")
endif()

message(STATUS "Writing to TARGET_FILE: ${TARGET_FILE}")

if (IS_DIRECTORY "${TARGET_FILE}")
    message(FATAL_ERROR "Error: TARGET_FILE is a directory, but expected a file: ${TARGET_FILE}")
endif()

if (NOT EXISTS "${TARGET_FILE}")
    message(FATAL_ERROR "Error: TARGET_FILE does not exist: ${TARGET_FILE}")
endif()

# Write modified content back to the file
file(WRITE "${TARGET_FILE}" "${NEW_CONTENT}")
