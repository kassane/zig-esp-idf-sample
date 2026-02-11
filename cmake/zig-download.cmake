if(NOT EXISTS "${ZIG_DIR}/zig")
    if(ZIG_PLATFORM STREQUAL "linux-musl")
        if(ZIG_ARCH STREQUAL "aarch64")
            set(HASH_SUM "45e28404358eaa6233a22460256f54a0ea33130252d25364bb1f0eb70000e861")
        elseif(ZIG_ARCH STREQUAL "x86_64")
            set(HASH_SUM "123cfce4aa80db09cf07ca8895a6f2302bf0f265f75eff7969c9cbf3863e3437")
        else()
            message(FATAL_ERROR "Unsupported architecture: ${ZIG_ARCH}")
        endif()
    elseif(ZIG_PLATFORM STREQUAL "windows")
        if(ZIG_ARCH STREQUAL "x86_64")
            set(HASH_SUM "d6b2ee84e499f0d67a5dee1cea20b1d6f0099d0665d809a49600984161672567")
        else()
            message(FATAL_ERROR "Unsupported architecture: ${ZIG_ARCH}")
        endif()
    elseif(ZIG_PLATFORM STREQUAL "macos")
        if(ZIG_ARCH STREQUAL "aarch64")
            set(HASH_SUM "9a884ca97ce55010e4d2500b090fc2565a61494313e6e9ba898bf41480d70b43")
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
