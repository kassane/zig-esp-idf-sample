/* stubs.h - Stubs file for zig translate-c with ESP-IDF */

#ifndef STUBS_H
#define STUBS_H

/* Prevent inclusion of problematic cstdlib headers */
#define _STDIO_H_
#define _STDLIB_H_
#define _STRING_H_
#define _WCHAR_H_
#define _SYS_STAT_H
#define _SYS_REENT_H
#define _SYS_TYPES_H
#define _SYS_SIGNAL_H
#define _SYS_TIME_H_
#define _SYS__DEFAULT_FCNTL_H_
#define _MBSTATE_T
#define _SYS_LOCK_H
#define _SYS_UNISTD_H
#define _UNISTD_H
#define _TIME_H_

/* Prevent real header from redefining them */
#define __ESP_ASSERT_H__
#define __ESP_VFS_H__

/* Avoid redefining types that exist in real headers */
#undef _mbstate_t
#undef __mbstate_t_defined

/* Define only what's strictly necessary without conflicting */
typedef void *FILE;
// typedef int _LOCK_T;
typedef void *__VALIST;
typedef long off_t;
typedef long _off_t;
typedef unsigned int wint_t;

/* Disable macros and attributes that confuse zig translate-c */
#define __restrict
#define __extension__
#define __attribute__(x)
#define __THROW
#define __wur
#define __volatile__
#define __inline
#ifdef static_assert
#undef static_assert
#endif
#define static_assert(expr, msg)

/* Disable IDF-specific attributes */
#define IRAM_ATTR
#define DRAM_ATTR
#define RTC_DATA_ATTR
#define SECTION_ATTR_IMPL(x, y)
#ifdef ESP_STATIC_ASSERT
#undef ESP_STATIC_ASSERT
#endif
#define ESP_STATIC_ASSERT(expr, msg)

/* Block multibyte functions from stdlib */
#define mblen
#define mbtowc
#define wctomb
#define mbstowcs
#define wcstombs

/* Workaround for FreeRTOS TLS dummy field (prevents struct _reent usage) */
#define configTLS_BLOCK_TYPE int
#define portTLS_BLOCK_TYPE int

/* ────────────────────────────────────────────────────────────────────────────
   IDF component guards – mirror sdkconfig.h / bindings.h logic
   Enable ONLY what your project actually uses
   ────────────────────────────────────────────────────────────────────────────
 */

/* Always available basics */
#define ESP_IDF_COMP_SOC_ENABLED
#define ESP_IDF_COMP_ESP_DRIVER_GPIO_ENABLED // almost always needed

/* Commonly used – uncomment what you need */
#define ESP_IDF_COMP_ESP_WIFI_ENABLED
#define ESP_IDF_COMP_ESP_NETIF_ENABLED
#define ESP_IDF_COMP_ESP_EVENT_ENABLED
#define ESP_IDF_COMP_NVS_FLASH_ENABLED
#define ESP_IDF_COMP_ESP_TIMER_ENABLED
#define ESP_IDF_COMP_ESP_PM_ENABLED
#define ESP_IDF_COMP_ESP_TLS_ENABLED
#define ESP_IDF_COMP_MBEDTLS_ENABLED
#define ESP_IDF_COMP_LWIP_ENABLED
#define ESP_IDF_COMP_VFS_ENABLED

/* Drivers (split since ~v5.1–5.3) – enable per driver you use */
#define ESP_IDF_COMP_ESP_DRIVER_UART_ENABLED
#define ESP_IDF_COMP_ESP_DRIVER_I2C_ENABLED
#define ESP_IDF_COMP_ESP_DRIVER_SPI_ENABLED
#define ESP_IDF_COMP_ESP_DRIVER_RMT_ENABLED
#define ESP_IDF_COMP_ESP_DRIVER_LEDC_ENABLED
#define ESP_IDF_COMP_ESP_DRIVER_GPTIMER_ENABLED
#define ESP_IDF_COMP_ESP_DRIVER_ADC_ENABLED
#define ESP_IDF_COMP_ESP_DRIVER_TWAI_ENABLED

/* Optional / advanced – enable only if used */
#define ESP_IDF_COMP_ESP_HTTP_CLIENT_ENABLED
#define ESP_IDF_COMP_ESP_HTTP_SERVER_ENABLED
#define ESP_IDF_COMP_ESP_HTTPS_OTA_ENABLED
#define ESP_IDF_COMP_ESP_NOW_ENABLED
#define ESP_IDF_COMP_WPA_SUPPLICANT_ENABLED
#define ESP_IDF_COMP_ESP_COEX_ENABLED
#define ESP_IDF_COMP_ESP_PSRAM_ENABLED // himem/psram
#define ESP_IDF_COMP_ESP_LCD_ENABLED

// #define ESP_IDF_COMP_ESPRESSIF__ESP_TINYUSB_ENABLED

/* Conditional component defines used in bindings.h */
#ifdef ESP_IDF_COMP_ESP_WIFI_ENABLED
#define ESP_IDF_COMP_ESP_NETIF_ENABLED
#endif
#ifdef ESP_IDF_COMP_WPA_SUPPLICANT_ENABLED
#define ESP_IDF_COMP_ESP_WIFI_ENABLED
#endif

/* Version-aware stubs */
#if ESP_IDF_VERSION_MAJOR >= 5
#define ESP_IDF_COMP_ESP_DRIVER_ENABLED 0 // drivers are now per-component
#else
#define ESP_IDF_COMP_DRIVER_ENABLED
#endif

#if ESP_IDF_VERSION_MAJOR >= 5 && ESP_IDF_VERSION_MINOR >= 1
#define ESP_IDF_COMP_ESP_COEX_ENABLED // coexist moved
#endif

#include <stddef.h>    // for size_t, ptrdiff_t, NULL
#include <stdint.h>    // for uint8_t, uint32_t, etc.
#include <sys/types.h> // for additional POSIX types

#include "sdkconfig.h"
/* Include AFTER all the protections */
#include "bindings.h"
#include "bt_stubs.h"
#include "wifi_stubs.h"

// Optional/Managed Components
// check cmake/extra-components.cmake
#if HAS_LED_STRIP
#include "led_strip.h"
#endif
#if HAS_ESP_DSP
#include "esp_dsp.h"
#endif

#endif // STUBS_H