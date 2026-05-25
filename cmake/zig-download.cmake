if(NOT EXISTS "${ZIG_DIR}/zig")
    if(ZIG_PLATFORM STREQUAL "linux-musl")
        if(ZIG_ARCH STREQUAL "aarch64")
            set(HASH_SUM "5304f43cd30dfcbdc555fde3e2b6501b4838322ba47dd71da34111e08b02eef4")
        elseif(ZIG_ARCH STREQUAL "x86_64")
            set(HASH_SUM "9e3dcef9d6f6d552df641a12addc9e443a69b7cbdad85492ec677acd55b7de9b")
        else()
            message(FATAL_ERROR "Unsupported architecture: ${ZIG_ARCH}")
        endif()
    elseif(ZIG_PLATFORM STREQUAL "windows")
        if(ZIG_ARCH STREQUAL "x86_64")
            set(HASH_SUM "f515bd0a11dcb48936883575552553596f8f6b872055d19b89a874d585e445e3")
        else()
            message(FATAL_ERROR "Unsupported architecture: ${ZIG_ARCH}")
        endif()
    elseif(ZIG_PLATFORM STREQUAL "macos")
        if(ZIG_ARCH STREQUAL "aarch64")
            set(HASH_SUM "7f5058c23ae822b9585ca054023676b7e07e48e4d1e265a6bd3104a55b0295ef")
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
