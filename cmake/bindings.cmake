# ────────────────────────────────────────────────────────────────────────────────
# Helper for downloading / referencing esp-rs/esp-idf-sys bindings.h
#
# This file is part of a Zig + ESP-IDF project using translate-c.
# It downloads the official bindings.h mega-header from esp-rs/esp-idf-sys
# as a reference (helps when improving stubs.h or comparing generated bindings).
#
# Huge thanks to the esp-rs community for maintaining esp-idf-sys
# Repository: https://github.com/esp-rs/esp-idf-sys
# bindings.h:  https://github.com/esp-rs/esp-idf-sys/blob/master/src/include/esp-idf/bindings.h
# ────────────────────────────────────────────────────────────────────────────────

set(BINDINGS_URL
    "https://raw.githubusercontent.com/esp-rs/esp-idf-sys/refs/heads/master/src/include/esp-idf/bindings.h"
)
set(BINDINGS_ESP_RS "${CMAKE_SOURCE_DIR}/include/bindings.h")
if(NOT EXISTS "${BINDINGS_ESP_RS}")
    message(STATUS "Downloading bindings.h from ${BINDINGS_URL}")
    file(DOWNLOAD ${BINDINGS_URL} ${BINDINGS_ESP_RS}
        TLS_VERIFY ON
        STATUS download_status
        LOG download_log
        TIMEOUT 15
    )
    list(GET download_status 0 status_code)
    list(GET download_status 1 error_msg)
    if(NOT status_code EQUAL 0)
        message(FATAL_ERROR "Failed to download esp-idf/bindings.h\nStatus: ${status_code}\nError: ${error_msg}\nLog:\n${download_log}")
    endif()
    message(STATUS "Downloaded esp-idf/bindings.h → ${BINDINGS_ESP_RS}")
else()
    message(STATUS "esp-idf/bindings.h already exists → ${BINDINGS_ESP_RS}")
endif()
