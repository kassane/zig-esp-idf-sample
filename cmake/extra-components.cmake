# ─── Optional/Managed Components Detection ───────────────────────────────────
idf_build_get_property(BUILD_COMPS BUILD_COMPONENTS)

# Helper function to check and add component
macro(check_managed_component COMPONENT_NAME VENDOR PACKAGE DEFINE_NAME)
    set(COMP_PATH "${CMAKE_SOURCE_DIR}/managed_components/${VENDOR}__${PACKAGE}/include")
    set(${DEFINE_NAME} 0)

    if("${VENDOR}__${PACKAGE}" IN_LIST BUILD_COMPS OR "${PACKAGE}" IN_LIST BUILD_COMPS)
        if(EXISTS "${COMP_PATH}")
            message(STATUS "${COMPONENT_NAME} component found: ${COMP_PATH}")
            set(${DEFINE_NAME} 1)
            list(APPEND INCLUDE_DIRS "${COMP_PATH}")
        else()
            message(WARNING "${COMPONENT_NAME} in components but path not found: ${COMP_PATH}")
        endif()
    else()
        message(STATUS "${COMPONENT_NAME} not in build. To add: idf.py add-dependency ${VENDOR}/${PACKAGE}")
    endif()

    list(APPEND EXTRA_DEFINE_FLAGS "-D${DEFINE_NAME}=${${DEFINE_NAME}}")
endmacro()

# add your components here - like this
check_managed_component("LED Strip" "espressif" "led_strip" "HAS_LED_STRIP")
check_managed_component("ESP-DSP" "espressif" "esp-dsp" "HAS_ESP_DSP")
check_managed_component("ESP BSP DevKit" "espressif" "esp_bsp_devkit" "HAS_ESP_BSP_DEVKIT")
