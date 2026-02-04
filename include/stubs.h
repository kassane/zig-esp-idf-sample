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

/* Define opaque types as simple replacements */
typedef void *FILE;
typedef void *struct__reent;
typedef int _mbstate_t;
typedef long off_t;
typedef long _off_t;
typedef unsigned int wint_t;
typedef int _LOCK_T;
typedef void *__VALIST;

/* Disable macros and attributes that confuse zig translate-c */
#define __restrict
#define __extension__
#define __attribute__(x)
#define __THROW
#define __wur
#define __volatile__
#define __inline

/* Disable IDF-specific section attributes that are not needed here */
#define IRAM_ATTR
#define DRAM_ATTR
#define RTC_DATA_ATTR
#define SECTION_ATTR_IMPL(x, y)

/* Block multibyte functions that appear in stdlib.h */
#define mblen
#define mbtowc
#define wctomb
#define mbstowcs
#define wcstombs

/* Include the real bindings AFTER all the protections */
#include "bindings.h"

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

const uint8_t g_espnow_user_oui[3] = {0x12, 0x34, 0x56};

#endif // STUBS_H