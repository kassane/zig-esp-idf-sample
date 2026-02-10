set(DEPS nvs_flash)
if(CONFIG_ESP_WIFI_ENABLED)
    list(APPEND DEPS esp_wifi esp_netif esp_event)
endif()
if(CONFIG_ESP_BT_ENABLED)
    list(APPEND DEPS bt)
endif()

idf_component_register(
    SRCS "placeholder.c"
    INCLUDE_DIRS "."
    REQUIRES ${DEPS}
)

include(${CMAKE_SOURCE_DIR}/cmake/zig-config.cmake)
