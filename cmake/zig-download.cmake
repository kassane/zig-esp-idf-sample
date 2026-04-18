if(NOT EXISTS "${ZIG_DIR}/zig")
    if(ZIG_PLATFORM STREQUAL "linux-musl")
        if(ZIG_ARCH STREQUAL "aarch64")
            set(HASH_SUM "d3e4930bbac053b40860290cdec2ad1e052418172aa452e590b242c081a01f94")
        elseif(ZIG_ARCH STREQUAL "x86_64")
            set(HASH_SUM "411f1858a9610803af28cd271acf4548873545ccc866f4b9060903ff0d4b6e8e")
        else()
            message(FATAL_ERROR "Unsupported architecture: ${ZIG_ARCH}")
        endif()
    elseif(ZIG_PLATFORM STREQUAL "windows")
        if(ZIG_ARCH STREQUAL "x86_64")
            set(HASH_SUM "4d5b66d857e790d068e408e6bdd0054f9e78ca2d0ab96b5ce25f63a125f1701e")
        else()
            message(FATAL_ERROR "Unsupported architecture: ${ZIG_ARCH}")
        endif()
    elseif(ZIG_PLATFORM STREQUAL "macos")
        if(ZIG_ARCH STREQUAL "aarch64")
            set(HASH_SUM "f47ac7927ae44f3b8290aa818d3158b0f9adc12742e03b7496ad440b6d89d38e")
        else()
            message(FATAL_ERROR "Unsupported architecture: ${ZIG_ARCH}")
        endif()
    endif()
    set(ZIG_URL "https://github.com/kassane/zig-espressif-bootstrap/releases/download/0.16.0-xtensa/zig-relsafe-${ZIG_TRIPLET}.${ARCHIVE_EXT}")
    message(STATUS "Downloading Zig (espressif variant):")
    message(STATUS "  => ${ZIG_ARCHIVE}")
    file(DOWNLOAD "${ZIG_URL}" "${ZIG_ARCHIVE}"
        TLS_VERIFY ON
        EXPECTED_HASH SHA256=${HASH_SUM}
        STATUS download_status
        LOG download_log
        # SHOW_PROGRESS
    )
    list(GET download_status 0 dl_code)
    if(NOT dl_code EQUAL 0)
        message(FATAL_ERROR "Download failed:\n${download_log}")
    endif()
    message(STATUS "Extracting ${ARCHIVE_EXT} ...")
    if(HOST_OS_LOWER MATCHES "windows|win")
        execute_process(
            COMMAND powershell -NoProfile -ExecutionPolicy Bypass
            -Command "Expand-Archive -Path '${ZIG_ARCHIVE}' -DestinationPath '${CMAKE_BINARY_DIR}' -Force"
            RESULT_VARIABLE extract_result
        )
    else()
        execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xf "${ZIG_ARCHIVE}"
            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
            RESULT_VARIABLE extract_result
        )
    endif()
    if(NOT extract_result EQUAL 0)
        message(FATAL_ERROR "Extraction failed (code ${extract_result})")
    endif()
    file(REMOVE "${ZIG_ARCHIVE}")
else()
    message(STATUS "Using cached espressif zig: ${ZIG_DIR}/zig")
endif()
set(ZIG_BIN "${ZIG_DIR}/zig")
