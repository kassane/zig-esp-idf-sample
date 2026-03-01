/*
 * matter_stubs.h — C wrapper interface for esp_matter (CHIP SDK C++ API)
 *
 * This header is included by stubs.h and processed by zig translate-c.
 * It provides a pure-C interface over the C++ esp_matter API.
 *
 * The actual implementations are in main/matter_wrappers.cpp (compiled as C++
 * by the ESP-IDF CMake build, with full access to CHIP SDK headers).
 *
 * NOTE: esp_matter_val_type_t, esp_matter_val_t, esp_matter_attr_val_t and
 * esp_matter_attr_bounds_t are also defined in the real esp_matter_attribute_utils.h.
 * Those definitions are guarded with #ifndef __cplusplus so that they are only
 * visible to zig translate-c (pure C mode).  In C++ compilation the real header
 * definitions are used, avoiding redefinition conflicts.
 */
#pragma once

#include <esp_err.h>
#include <stdbool.h>
#include <stdint.h>

/* ── Opaque handle types ─────────────────────────────────────────────────── */
/* These names do not exist in the real esp_matter C++ headers (which use
 * node_t / endpoint_t inside namespaces), so they are safe to define in
 * both C and C++ compilation contexts.                                      */

typedef size_t esp_matter_node_t;
typedef size_t esp_matter_endpoint_t;
typedef size_t esp_matter_cluster_t;
typedef size_t esp_matter_attribute_t;

/* ── Endpoint flags ──────────────────────────────────────────────────────── */
/* Real esp_matter uses ENDPOINT_FLAG_* (no prefix); these names are unique. */

typedef enum esp_matter_ep_flags {
    ESP_MATTER_EP_FLAG_NONE        = 0x00,
    ESP_MATTER_EP_FLAG_DESTROYABLE = 0x01,
    ESP_MATTER_EP_FLAG_BRIDGE      = 0x02,
} esp_matter_ep_flags_t;

/* ── Types that ALSO exist in esp_matter_attribute_utils.h ───────────────── */
/* Guarded so the real header wins in C++ compilation.                        */

#ifndef __cplusplus

typedef enum esp_matter_val_type {
    ESP_MATTER_VAL_TYPE_INVALID            = 0,
    ESP_MATTER_VAL_TYPE_BOOLEAN            = 1,
    ESP_MATTER_VAL_TYPE_INTEGER            = 2,
    ESP_MATTER_VAL_TYPE_FLOAT              = 3,
    ESP_MATTER_VAL_TYPE_ARRAY              = 4,
    ESP_MATTER_VAL_TYPE_CHAR_STRING        = 5,
    ESP_MATTER_VAL_TYPE_OCTET_STRING       = 6,
    ESP_MATTER_VAL_TYPE_INT8               = 7,
    ESP_MATTER_VAL_TYPE_UINT8              = 8,
    ESP_MATTER_VAL_TYPE_INT16              = 9,
    ESP_MATTER_VAL_TYPE_UINT16             = 10,
    ESP_MATTER_VAL_TYPE_INT32              = 11,
    ESP_MATTER_VAL_TYPE_UINT32             = 12,
    ESP_MATTER_VAL_TYPE_INT64              = 13,
    ESP_MATTER_VAL_TYPE_UINT64             = 14,
    ESP_MATTER_VAL_TYPE_ENUM8              = 15,
    ESP_MATTER_VAL_TYPE_BITMAP8            = 16,
    ESP_MATTER_VAL_TYPE_BITMAP16           = 17,
    ESP_MATTER_VAL_TYPE_BITMAP32           = 18,
    ESP_MATTER_VAL_TYPE_ENUM16             = 19,
    ESP_MATTER_VAL_TYPE_LONG_CHAR_STRING   = 20,
    ESP_MATTER_VAL_TYPE_LONG_OCTET_STRING  = 21,
} esp_matter_val_type_t;

/** Attribute value union — binary-compatible with esp_matter_val_t */
typedef union esp_matter_val {
    bool     b;
    int      i;
    float    f;
    int8_t   i8;
    uint8_t  u8;
    int16_t  i16;
    uint16_t u16;
    int32_t  i32;
    uint32_t u32;
    int64_t  i64;
    uint64_t u64;
    struct {
        uint8_t  *b;   /* buffer pointer */
        uint16_t  s;   /* data size */
        uint16_t  n;   /* element count */
        uint16_t  t;   /* total allocated size */
    } a;               /* array / string */
    void *p;
} esp_matter_val_t;

/** Attribute value struct — binary-compatible with esp_matter_attr_val_t */
typedef struct esp_matter_attr_val {
    esp_matter_val_type_t type;
    esp_matter_val_t      val;
} esp_matter_attr_val_t;

/** Attribute bounds */
typedef struct esp_matter_attr_bounds {
    esp_matter_attr_val_t min;
    esp_matter_attr_val_t max;
} esp_matter_attr_bounds_t;

#endif /* !__cplusplus */

/* ── Attribute callback ──────────────────────────────────────────────────── */
/* These types are unique to our C wrapper (not in real esp_matter headers).
 * They must be visible in both C and C++ so the extern "C" function
 * declarations below can use them.  In C++ mode esp_matter_attr_val_t is
 * provided by the previously-included real esp_matter_attribute_utils.h.    */

typedef enum esp_matter_attr_cb_type {
    ESP_MATTER_ATTR_CB_PRE_UPDATE = 0,
    ESP_MATTER_ATTR_CB_POST_UPDATE,
    ESP_MATTER_ATTR_CB_READ,
    ESP_MATTER_ATTR_CB_WRITE,
} esp_matter_attr_cb_type_t;

/**
 * Attribute update callback — called before/after every attribute change.
 * Return ESP_OK to allow the update; return error from PRE_UPDATE to block it.
 */
typedef esp_err_t (*esp_matter_attr_callback_t)(
    esp_matter_attr_cb_type_t  type,
    uint16_t                   endpoint_id,
    uint32_t                   cluster_id,
    uint32_t                   attribute_id,
    esp_matter_attr_val_t     *val,
    void                      *priv_data);

/* ── Identification (Identify cluster) callback ──────────────────────────── */

typedef enum esp_matter_identify_cb_type {
    ESP_MATTER_IDENTIFY_CB_START = 0,
    ESP_MATTER_IDENTIFY_CB_STOP,
    ESP_MATTER_IDENTIFY_CB_EFFECT,
} esp_matter_identify_cb_type_t;

typedef esp_err_t (*esp_matter_identify_callback_t)(
    esp_matter_identify_cb_type_t  type,
    uint16_t                       endpoint_id,
    uint8_t                        effect_id,
    uint8_t                        effect_variant,
    void                          *priv_data);

/* ── Function declarations ───────────────────────────────────────────────── */

#ifdef __cplusplus
extern "C" {
#endif

/** Start the Matter stack (call after building node + endpoints). */
esp_err_t esp_matter_wrapper_start(
    esp_matter_attr_callback_t     attr_cb,
    esp_matter_identify_callback_t identify_cb);

/** Perform a factory reset (erases NVS, then reboots). */
esp_err_t esp_matter_wrapper_factory_reset(void);

/** Return true if Matter has been started. */
bool esp_matter_wrapper_is_started(void);

/* ── Node ────────────────────────────────────────────────────────────────── */

/**
 * Create a root node (endpoint 0) with default config.
 * attr_cb and identify_cb are stored for the lifetime of the node.
 * priv_data is forwarded to both callbacks.
 */
esp_matter_node_t *esp_matter_wrapper_node_create(
    esp_matter_attr_callback_t     attr_cb,
    esp_matter_identify_callback_t identify_cb,
    void                          *priv_data);

/* ── Endpoint ────────────────────────────────────────────────────────────── */

/** Create a generic endpoint on the node. */
esp_matter_endpoint_t *esp_matter_wrapper_endpoint_create(
    esp_matter_node_t *node,
    uint8_t            flags,
    void              *priv_data);

/** Destroy an endpoint (only valid if ENDPOINT_FLAG_DESTROYABLE was set). */
esp_err_t esp_matter_wrapper_endpoint_destroy(
    esp_matter_node_t    *node,
    esp_matter_endpoint_t *endpoint);

/** Return the endpoint ID assigned by the stack. */
uint16_t esp_matter_wrapper_endpoint_get_id(esp_matter_endpoint_t *endpoint);

/** Associate a device type with an endpoint. */
esp_err_t esp_matter_wrapper_endpoint_add_device_type(
    esp_matter_endpoint_t *endpoint,
    uint32_t               device_type_id,
    uint8_t                version);

/** Enable a dynamically-created endpoint (call after esp_matter::start()). */
esp_err_t esp_matter_wrapper_endpoint_enable(esp_matter_endpoint_t *endpoint);

/* ── Pre-built device-type endpoints ─────────────────────────────────────── */

/** Create an On/Off Light endpoint (EP_FLAG_NONE recommended). */
esp_matter_endpoint_t *esp_matter_wrapper_add_on_off_light(
    esp_matter_node_t *node,
    uint8_t            flags,
    void              *priv_data);

/** Create an On/Off Switch endpoint. */
esp_matter_endpoint_t *esp_matter_wrapper_add_on_off_switch(
    esp_matter_node_t *node,
    uint8_t            flags,
    void              *priv_data);

/** Create a Dimmable Light endpoint. */
esp_matter_endpoint_t *esp_matter_wrapper_add_dimmable_light(
    esp_matter_node_t *node,
    uint8_t            flags,
    void              *priv_data);

/** Create a Color Temperature Light endpoint. */
esp_matter_endpoint_t *esp_matter_wrapper_add_color_temperature_light(
    esp_matter_node_t *node,
    uint8_t            flags,
    void              *priv_data);

/* ── Cluster ─────────────────────────────────────────────────────────────── */

/** Create a cluster on an endpoint. */
esp_matter_cluster_t *esp_matter_wrapper_cluster_create(
    esp_matter_endpoint_t *endpoint,
    uint32_t               cluster_id,
    uint8_t                flags);

/* ── Attribute ───────────────────────────────────────────────────────────── */

/** Create an attribute on a cluster. */
esp_matter_attribute_t *esp_matter_wrapper_attribute_create(
    esp_matter_cluster_t  *cluster,
    uint32_t               attribute_id,
    uint16_t               flags,
    esp_matter_attr_val_t  val);

/** Update an attribute value (use after esp_matter::start()). */
esp_err_t esp_matter_wrapper_attribute_update(
    uint16_t               endpoint_id,
    uint32_t               cluster_id,
    uint32_t               attribute_id,
    esp_matter_attr_val_t *val);

/** Get an attribute value. */
esp_err_t esp_matter_wrapper_attribute_get_val(
    esp_matter_attribute_t *attribute,
    esp_matter_attr_val_t  *val);

/** Set an attribute value (use before esp_matter::start()). */
esp_err_t esp_matter_wrapper_attribute_set_val(
    esp_matter_attribute_t *attribute,
    esp_matter_attr_val_t  *val);

#ifdef __cplusplus
} /* extern "C" */
#endif

/* ── Convenience attribute constructors (C-only; use real esp_matter_* in C++) */
#ifndef __cplusplus

static inline esp_matter_attr_val_t esp_matter_val_bool(bool val) {
    esp_matter_attr_val_t v;
    v.type = ESP_MATTER_VAL_TYPE_BOOLEAN;
    v.val.b = val;
    return v;
}
static inline esp_matter_attr_val_t esp_matter_val_uint8(uint8_t val) {
    esp_matter_attr_val_t v;
    v.type = ESP_MATTER_VAL_TYPE_UINT8;
    v.val.u8 = val;
    return v;
}
static inline esp_matter_attr_val_t esp_matter_val_uint16(uint16_t val) {
    esp_matter_attr_val_t v;
    v.type = ESP_MATTER_VAL_TYPE_UINT16;
    v.val.u16 = val;
    return v;
}
static inline esp_matter_attr_val_t esp_matter_val_uint32(uint32_t val) {
    esp_matter_attr_val_t v;
    v.type = ESP_MATTER_VAL_TYPE_UINT32;
    v.val.u32 = val;
    return v;
}
static inline esp_matter_attr_val_t esp_matter_val_int16(int16_t val) {
    esp_matter_attr_val_t v;
    v.type = ESP_MATTER_VAL_TYPE_INT16;
    v.val.i16 = val;
    return v;
}
static inline esp_matter_attr_val_t esp_matter_val_nullable(void) {
    esp_matter_attr_val_t v;
    v.type = ESP_MATTER_VAL_TYPE_INVALID;
    v.val.u64 = 0;
    return v;
}

#endif /* !__cplusplus */
