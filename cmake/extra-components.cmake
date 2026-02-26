# ─── Optional/Managed Components Detection ───────────────────────────────────
idf_build_get_property(BUILD_COMPS BUILD_COMPONENTS)

# Get IDF_PATH from environment
set(IDF_PATH $ENV{IDF_PATH})

# Include version.cmake to get IDF_VERSION_MAJOR, IDF_VERSION_MINOR, etc.
if(EXISTS "${IDF_PATH}/tools/cmake/version.cmake")
    include("${IDF_PATH}/tools/cmake/version.cmake")
else()
    message(FATAL_ERROR "Failed to find version.cmake in ${IDF_PATH}/tools/cmake")
endif()


# Helper function to check and add component
macro(check_managed_component COMPONENT_NAME VENDOR PACKAGE DEFINE_NAME)
    set(COMP_PATHS "")
    set(COMP_BASE "${CMAKE_SOURCE_DIR}/managed_components/${VENDOR}__${PACKAGE}")

    if("${PACKAGE}" STREQUAL "esp-dsp")
        list(APPEND COMP_PATHS
            "${COMP_BASE}/modules/common/include"
            "${COMP_BASE}/modules/dotprod/include"
            "${COMP_BASE}/modules/support/include"
            "${COMP_BASE}/modules/support/mem/include"
            "${COMP_BASE}/modules/windows/include"
            "${COMP_BASE}/modules/windows/hann/include"
            "${COMP_BASE}/modules/windows/blackman/include"
            "${COMP_BASE}/modules/windows/blackman_harris/include"
            "${COMP_BASE}/modules/windows/blackman_nuttall/include"
            "${COMP_BASE}/modules/windows/nuttall/include"
            "${COMP_BASE}/modules/windows/flat_top/include"
            "${COMP_BASE}/modules/iir/include"
            "${COMP_BASE}/modules/fir/include"
            "${COMP_BASE}/modules/math/include"
            "${COMP_BASE}/modules/math/add/include"
            "${COMP_BASE}/modules/math/sub/include"
            "${COMP_BASE}/modules/math/mul/include"
            "${COMP_BASE}/modules/math/addc/include"
            "${COMP_BASE}/modules/math/mulc/include"
            "${COMP_BASE}/modules/math/sqrt/include"
            "${COMP_BASE}/modules/matrix/include"
            "${COMP_BASE}/modules/matrix/mul/include"
            "${COMP_BASE}/modules/matrix/add/include"
            "${COMP_BASE}/modules/matrix/addc/include"
            "${COMP_BASE}/modules/matrix/mulc/include"
            "${COMP_BASE}/modules/matrix/sub/include"
            "${COMP_BASE}/modules/fft/include"
            "${COMP_BASE}/modules/dct/include"
            "${COMP_BASE}/modules/conv/include"
            "${COMP_BASE}/modules/kalman/ekf/include"
            "${COMP_BASE}/modules/kalman/ekf_imu13states/include"
        )
    elseif("${PACKAGE}" STREQUAL "esp_wifi_remote")
        # Add base include if exists
        set(BASE_INCLUDE "${COMP_BASE}/include")
        if(EXISTS "${BASE_INCLUDE}")
            list(APPEND COMP_PATHS "${BASE_INCLUDE}")
        endif()

        # Add version-specific include using MAJOR.MINOR
        set(VERSION_SUBDIR "idf_v${IDF_VERSION_MAJOR}.${IDF_VERSION_MINOR}")
        set(VERSION_PATH "${COMP_BASE}/${VERSION_SUBDIR}/include")
        if(EXISTS "${VERSION_PATH}")
            list(APPEND COMP_PATHS "${VERSION_PATH}")
        endif()
    elseif("${PACKAGE}" STREQUAL "esp_hosted")
        # Add host and api include paths for esp_hosted
        set(HOST_PATH "${COMP_BASE}/host")
        if(EXISTS "${HOST_PATH}")
            list(APPEND COMP_PATHS "${HOST_PATH}")
        endif()
        set(API_PATH "${COMP_BASE}/host/api/include")
        if(EXISTS "${API_PATH}")
            list(APPEND COMP_PATHS "${API_PATH}")
        endif()
    else()
        list(APPEND COMP_PATHS "${COMP_BASE}/include")
    endif()

    # Check if component is in build
    if("${VENDOR}__${PACKAGE}" IN_LIST BUILD_COMPS OR "${PACKAGE}" IN_LIST BUILD_COMPS)
        # Verify at least one path exists (check the base directory)
        if(EXISTS "${COMP_BASE}")
            message(STATUS "${COMPONENT_NAME} component found")
            set(${DEFINE_NAME} 1)

            # Add all include paths that actually exist
            set(VALID_PATHS 0)
            foreach(COMP_PATH IN LISTS COMP_PATHS)
                if(EXISTS "${COMP_PATH}")
                    list(APPEND INCLUDE_DIRS "${COMP_PATH}")
                    math(EXPR VALID_PATHS "${VALID_PATHS} + 1")
                endif()
            endforeach()

            if(VALID_PATHS GREATER 0)
                message(STATUS "  Added ${VALID_PATHS} include paths for ${COMPONENT_NAME}")
            else()
                message(WARNING "${COMPONENT_NAME} base exists but no include paths found")
                set(${DEFINE_NAME} 0)
            endif()
        else()
            message(WARNING "${COMPONENT_NAME} in components but not found: ${COMP_BASE}")
            set(${DEFINE_NAME} 0)
        endif()
    else()
        message(STATUS "${COMPONENT_NAME} not in build. To add: idf.py add-dependency ${VENDOR}/${PACKAGE}")
        set(${DEFINE_NAME} 0)
    endif()

    list(APPEND EXTRA_DEFINE_FLAGS "-D${DEFINE_NAME}=${${DEFINE_NAME}}")
endmacro()

# Add your components here
check_managed_component("LED Strip" "espressif" "led_strip" "HAS_LED_STRIP")
check_managed_component("ESP-DSP" "espressif" "esp-dsp" "HAS_ESP_DSP")
check_managed_component("ESP Wifi Remote" "espressif" "esp_wifi_remote" "HAS_ESP_WIFI_REMOTE")
check_managed_component("ESP Hosted" "espressif" "esp_hosted" "HAS_ESP_HOSTED")
