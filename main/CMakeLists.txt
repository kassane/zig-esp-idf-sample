set(DEPS esp_wifi nvs_flash bt)

idf_component_register(SRCS "placeholder.c"
    INCLUDE_DIRS "."
    PRIV_REQUIRES "${DEPS}"
)

include(${CMAKE_SOURCE_DIR}/cmake/zig-config.cmake)
