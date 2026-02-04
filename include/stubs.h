/* stubs.h - Stubs file for zig translate-c with ESP-IDF */

#ifndef STUBS_H
#define STUBS_H

#define IRAM_ATTR _SECTION_ATTR_IMPL(".iram1", __COUNTER__)

/* Prevent inclusion of problematic cstdlib headers */
#define _STDIO_H_
#define _STDLIB_H_
#define _STRING_H_
#define _WCHAR_H_
#define _SYS_TYPES_H
#define _SYS_REENT_H
#define _MBSTATE_T
#define _SYS_LOCK_H
#define _UNISTD_H
#define _TIME_H

/* Avoid redefining types that exist in real headers */
#undef _mbstate_t
#undef __mbstate_t_defined

/* Define only what's strictly necessary without conflicting */
typedef void *FILE;
typedef int _LOCK_T;
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

/* Include AFTER all the protections */
#include "driver/gpio.h"
#include "driver/i2c.h"
#include "driver/i2s_common.h"
#include "driver/spi_master.h"
#include "driver/spi_slave.h"
#include "driver/uart.h"
#include "esp_attr.h"
#include "esp_event.h"
#include "esp_event_base.h"
#include "esp_flash.h"
#include "esp_heap_caps.h"
#include "esp_log.h"
#include "esp_netif_types.h"
#include "esp_system.h"
#include "esp_wifi.h"
#include "freertos/FreeRTOS.h"
#include "freertos/event_groups.h"
#include "freertos/task.h"
#include "hal/assert.h"
#include "hal/gpio_types.h"
#include "hal/i2s_types.h"
#include "nvs_flash.h"
#include "soc/gpio_num.h"

/* The examples use WiFi configuration that you can set via project
   configuration menu

   If you'd rather not, just change the below entries to strings with
   the config you want - ie #define EXAMPLE_WIFI_SSID "mywifissid"
*/
#define EXAMPLE_ESP_WIFI_SSID CONFIG_ESP_WIFI_SSID
#define EXAMPLE_ESP_WIFI_PASS CONFIG_ESP_WIFI_PASSWORD
#define EXAMPLE_ESP_MAXIMUM_RETRY CONFIG_ESP_MAXIMUM_RETRY

#if CONFIG_ESP_WPA3_SAE_PWE_HUNT_AND_PECK
#define ESP_WIFI_SAE_MODE WPA3_SAE_PWE_HUNT_AND_PECK
#define EXAMPLE_H2E_IDENTIFIER ""
#elif CONFIG_ESP_WPA3_SAE_PWE_HASH_TO_ELEMENT
#define ESP_WIFI_SAE_MODE WPA3_SAE_PWE_HASH_TO_ELEMENT
#define EXAMPLE_H2E_IDENTIFIER CONFIG_ESP_WIFI_PW_ID
#elif CONFIG_ESP_WPA3_SAE_PWE_BOTH
#define ESP_WIFI_SAE_MODE WPA3_SAE_PWE_BOTH
#define EXAMPLE_H2E_IDENTIFIER CONFIG_ESP_WIFI_PW_ID
#endif
#if CONFIG_ESP_WIFI_AUTH_OPEN
#define ESP_WIFI_SCAN_AUTH_MODE_THRESHOLD WIFI_AUTH_OPEN
#elif CONFIG_ESP_WIFI_AUTH_WEP
#define ESP_WIFI_SCAN_AUTH_MODE_THRESHOLD WIFI_AUTH_WEP
#elif CONFIG_ESP_WIFI_AUTH_WPA_PSK
#define ESP_WIFI_SCAN_AUTH_MODE_THRESHOLD WIFI_AUTH_WPA_PSK
#elif CONFIG_ESP_WIFI_AUTH_WPA2_PSK
#define ESP_WIFI_SCAN_AUTH_MODE_THRESHOLD WIFI_AUTH_WPA2_PSK
#elif CONFIG_ESP_WIFI_AUTH_WPA_WPA2_PSK
#define ESP_WIFI_SCAN_AUTH_MODE_THRESHOLD WIFI_AUTH_WPA_WPA2_PSK
#elif CONFIG_ESP_WIFI_AUTH_WPA3_PSK
#define ESP_WIFI_SCAN_AUTH_MODE_THRESHOLD WIFI_AUTH_WPA3_PSK
#elif CONFIG_ESP_WIFI_AUTH_WPA2_WPA3_PSK
#define ESP_WIFI_SCAN_AUTH_MODE_THRESHOLD WIFI_AUTH_WPA2_WPA3_PSK
#elif CONFIG_ESP_WIFI_AUTH_WAPI_PSK
#define ESP_WIFI_SCAN_AUTH_MODE_THRESHOLD WIFI_AUTH_WAPI_PSK
#endif

/* FreeRTOS event group to signal when we are connected*/
static EventGroupHandle_t s_wifi_event_group;

/* The event group allows multiple bits for each event, but we only care about
 * two events:
 * - we are connected to the AP with an IP
 * - we failed to connect after the maximum amount of retries */
#define WIFI_CONNECTED_BIT BIT0
#define WIFI_FAIL_BIT BIT1

#endif // STUBS_H