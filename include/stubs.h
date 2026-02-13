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

/* Disable IDF-specific attributes */
#define IRAM_ATTR
#define DRAM_ATTR
#define RTC_DATA_ATTR
#define SECTION_ATTR_IMPL(x, y)

/* Block multibyte functions from stdlib */
#define mblen
#define mbtowc
#define wctomb
#define mbstowcs
#define wcstombs

/* Workaround for FreeRTOS TLS dummy field (prevents struct _reent usage) */
#define configTLS_BLOCK_TYPE int
#define portTLS_BLOCK_TYPE int

#include <stddef.h>    // for size_t, ptrdiff_t, NULL
#include <stdint.h>    // for uint8_t, uint32_t, etc.
#include <sys/types.h> // for additional POSIX types

/* Include AFTER all the protections */
#include "sdkconfig.h"
#ifdef CONFIG_ESP_WIFI_ENABLED
#define ESP_IDF_COMP_ESP_WIFI_ENABLED
#define ESP_IDF_COMP_ESP_NETIF_ENABLED
#endif
#ifdef CONFIG_WPA_SUPPLICANT_ENABLED
#define ESP_IDF_COMP_WPA_SUPPLICANT_ENABLED
#endif
#ifdef CONFIG_ESP_COEX_ENABLED
#define ESP_IDF_COMP_ESP_COEX_ENABLED
#endif
#ifdef CONFIG_ESP_WIFI_NVS_ENABLED
#define ESP_IDF_COMP_NVS_FLASH_ENABLED
#endif
#ifdef CONFIG_SOC_GPIO_PORT
#define ESP_IDF_COMP_ESP_DRIVER_GPIO_ENABLED
#endif
#include "bindings.h"
#include "wifi_stubs.h"

#endif // STUBS_H