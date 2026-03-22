if(NOT EXISTS "${ZIG_DIR}/zig")
    if(ZIG_PLATFORM STREQUAL "linux-musl")
        if(ZIG_ARCH STREQUAL "aarch64")
            set(HASH_SUM "5301b435f05efae235a836f90739fd0eac719f53583b1ddb75400bbe419ba409")
        elseif(ZIG_ARCH STREQUAL "x86_64")
            set(HASH_SUM "c52a3a1650909de30afce42eefce9d2e0d052760aa68ead8b9637ef9eaf8d738")
        else()
            message(FATAL_ERROR "Unsupported architecture: ${ZIG_ARCH}")
        endif()
    elseif(ZIG_PLATFORM STREQUAL "windows")
        if(ZIG_ARCH STREQUAL "x86_64")
            set(HASH_SUM "a3ff9a1d25889cc9c67be461c89e65f1573c9e8ced0d0a2e1806083ee2adbe3e")
        else()
            message(FATAL_ERROR "Unsupported architecture: ${ZIG_ARCH}")
        endif()
    elseif(ZIG_PLATFORM STREQUAL "macos")
        if(ZIG_ARCH STREQUAL "aarch64")
            set(HASH_SUM "cfb9ac6cb70e22e7e731243a6a4e166b04e5fa6f038642e226ec2b4f6ac6eeaf")
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
