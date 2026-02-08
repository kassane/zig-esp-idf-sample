if(NOT EXISTS "${ZIG_DIR}/zig")
    if(ZIG_PLATFORM STREQUAL "linux-musl")
        if(ZIG_ARCH STREQUAL "aarch64")
            set(HASH_SUM "f228441e7ab1d0f1c48a37df2802f456a36e1a50e8a9389fd9f02bdd4ccfb964")
        elseif(ZIG_ARCH STREQUAL "x86_64")
            set(HASH_SUM "314d6e29abf55e8eb46ada46fa967713128492cc0d0fb7ff9a955da0dcea83e4")
        else()
            message(FATAL_ERROR "Unsupported architecture: ${ZIG_ARCH}")
        endif()
    elseif(ZIG_PLATFORM STREQUAL "windows")
        if(ZIG_ARCH STREQUAL "x86_64")
            set(HASH_SUM "5c344f6773a596382d2ba77e1915ae68f16d3da51a20e0e529c39c079fc13737")
        else()
            message(FATAL_ERROR "Unsupported architecture: ${ZIG_ARCH}")
        endif()
    elseif(ZIG_PLATFORM STREQUAL "macos")
        if(ZIG_ARCH STREQUAL "aarch64")
            set(HASH_SUM "25b86e08481580b123b3c942b9b51590a9d5dbc662d499f59a5108b1104bd742")
        else()
            message(FATAL_ERROR "Unsupported architecture: ${ZIG_ARCH}")
        endif()
    endif()
    set(ZIG_URL "https://github.com/kassane/zig-espressif-bootstrap/releases/download/0.16.0-xtensa-dev/zig-relsafe-${ZIG_TRIPLET}.${ARCHIVE_EXT}")
    message(STATUS "Downloading Zig (espressif variant):")
    message(STATUS "  => ${ZIG_ARCHIVE}")
    file(DOWNLOAD "${ZIG_URL}" "${ZIG_ARCHIVE}"
        TLS_VERIFY ON
        EXPECTED_HASH SHA256=${HASH_SUM}
        STATUS download_status
        LOG download_log
        SHOW_PROGRESS
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
