# ──────────────────────────────────────────────────────────────────────────────
# Download translate_c-standalone
# ──────────────────────────────────────────────────────────────────────────────

# Determine platform triple for translate_c-standalone naming
if(ZIG_PLATFORM STREQUAL "linux-musl")
    if(ZIG_ARCH STREQUAL "aarch64")
        set(TRANSLATE_C_TRIPLE "aarch64-linux-musl")
        set(HASH_SUM "7d5968a41a02064d90035db95ef102fc2ab5e71a2eb48ba6cf028eb79b4ae43d")
    elseif(ZIG_ARCH STREQUAL "x86_64")
        set(TRANSLATE_C_TRIPLE "x86_64-linux-musl")
        set(HASH_SUM "d098e2675fc6706914b6e53dd72f6536895420460f287e73e19772c979fabb84")
    else()
        message(FATAL_ERROR "Unsupported architecture for translate_c-standalone: ${ZIG_ARCH}")
    endif()
    set(ARCHIVE_EXT "tar.xz")
elseif(ZIG_PLATFORM STREQUAL "windows")
    if(ZIG_ARCH STREQUAL "x86_64")
        set(TRANSLATE_C_TRIPLE "x86_64-windows-gnu")
        set(HASH_SUM "8e53a03ee44983eea2786c2ba028e83a816b9a993a768b3f4ca8c6e3525923e2")
    else()
        message(FATAL_ERROR "Unsupported architecture for translate_c-standalone: ${ZIG_ARCH}")
    endif()
    set(ARCHIVE_EXT "zip")
elseif(ZIG_PLATFORM STREQUAL "macos")
    if(ZIG_ARCH STREQUAL "aarch64")
        set(TRANSLATE_C_TRIPLE "aarch64-macos")
        set(HASH_SUM "8b3d2360d09add35f764ac138e0ec497503dc3de788a01e93fd7b9923a44369c")
    else()
        message(FATAL_ERROR "Unsupported architecture for translate_c-standalone: ${ZIG_ARCH}")
    endif()
    set(ARCHIVE_EXT "tar.xz")
else()
    message(FATAL_ERROR "Unsupported platform for translate_c-standalone: ${ZIG_PLATFORM}")
endif()

set(TRANSLATE_C_DIR "${CMAKE_BINARY_DIR}/translate_c-standalone")
set(TRANSLATE_C_ARCHIVE "${CMAKE_BINARY_DIR}/translate_c-standalone-${TRANSLATE_C_TRIPLE}-baseline.${ARCHIVE_EXT}")
set(TRANSLATE_C_BIN "${TRANSLATE_C_DIR}/bin")

# Download if not already extracted
if(NOT EXISTS "${TRANSLATE_C_BIN}")
    set(TRANSLATE_C_URL "https://github.com/kassane/zig-espressif-bootstrap/releases/download/0.16.0-xtensa-dev/translate_c-standalone-${TRANSLATE_C_TRIPLE}-baseline.${ARCHIVE_EXT}")

    message(STATUS "Downloading translate_c-standalone (${TRANSLATE_C_TRIPLE}):")
    message(STATUS "  => ${TRANSLATE_C_ARCHIVE}")

    file(DOWNLOAD "${TRANSLATE_C_URL}" "${TRANSLATE_C_ARCHIVE}"
        TLS_VERIFY ON
        EXPECTED_HASH SHA256=${HASH_SUM}
        STATUS download_status
        LOG download_log
    )

    list(GET download_status 0 dl_code)
    if(NOT dl_code EQUAL 0)
        message(FATAL_ERROR "Download failed:\n${download_log}")
    endif()

    message(STATUS "Extracting ${ARCHIVE_EXT} ...")
    file(MAKE_DIRECTORY "${TRANSLATE_C_DIR}")

    if(HOST_OS_LOWER MATCHES "windows|win")
        execute_process(
            COMMAND powershell -NoProfile -ExecutionPolicy Bypass
            -Command "Expand-Archive -Path '${TRANSLATE_C_ARCHIVE}' -DestinationPath '${TRANSLATE_C_DIR}' -Force"
            RESULT_VARIABLE extract_result
        )
    else()
        execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xf "${TRANSLATE_C_ARCHIVE}"
            WORKING_DIRECTORY "${TRANSLATE_C_DIR}"
            RESULT_VARIABLE extract_result
        )
    endif()

    if(NOT extract_result EQUAL 0)
        message(FATAL_ERROR "Extraction failed (code ${extract_result})")
    endif()

    file(REMOVE "${TRANSLATE_C_ARCHIVE}")

    # Make executable on Unix
    if(NOT HOST_OS_LOWER MATCHES "windows|win")
        execute_process(
            COMMAND chmod +x "${TRANSLATE_C_BIN}"
            RESULT_VARIABLE chmod_result
        )
        if(NOT chmod_result EQUAL 0)
            message(WARNING "Failed to set executable bit on translate_c-standalone")
        endif()
    endif()

    message(STATUS "translate_c-standalone ready at: ${TRANSLATE_C_BIN}")
else()
    message(STATUS "Using cached translate_c-standalone: ${TRANSLATE_C_BIN}")
endif()
set(TRANSLATE_ZIG "${TRANSLATE_C_BIN}/translate-c")
