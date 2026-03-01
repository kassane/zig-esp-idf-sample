/*
 * matter_wrappers.cpp — extern "C" shims that bridge the C wrapper interface
 * (matter_stubs.h) to the C++ esp_matter API.
 *
 * This file is compiled as C++ by the ESP-IDF CMake build, giving it full
 * access to CHIP SDK headers and the esp_matter C++ namespace.
 */

#include <esp_err.h>
#include <esp_matter.h>
#include <esp_matter_core.h>
#include <esp_matter_identify.h>
#include <esp_matter_attribute_utils.h>
#include <esp_matter_endpoint.h>
#include <esp_matter_cluster.h>
#include <esp_matter_attribute.h>
#include <esp_matter_data_model.h>
#include <esp_log.h>

#include "matter_stubs.h"

static const char *TAG = "matter_wrap";

/* ── Type alias shorthands ────────────────────────────────────────────────── */

using namespace esp_matter;

/* ── Callback adapter types ───────────────────────────────────────────────── */

/*
 * The C callback types in matter_stubs.h are binary-compatible with the C++
 * types declared in esp_matter_attribute_utils.h and esp_matter_identify.h.
 * We use reinterpret_cast to pass them across the ABI boundary.
 */

static attribute::callback_t s_attr_cb  = nullptr;
static identification::callback_t s_ident_cb = nullptr;

/* ── Core ─────────────────────────────────────────────────────────────────── */

extern "C" esp_err_t esp_matter_wrapper_start(
    esp_matter_attr_callback_t     attr_cb,
    esp_matter_identify_callback_t identify_cb)
{
    s_attr_cb  = reinterpret_cast<attribute::callback_t>(attr_cb);
    s_ident_cb = reinterpret_cast<identification::callback_t>(identify_cb);
    return esp_matter::start(nullptr);
}

extern "C" esp_err_t esp_matter_wrapper_factory_reset(void)
{
    return esp_matter::factory_reset();
}

extern "C" bool esp_matter_wrapper_is_started(void)
{
    return esp_matter::is_started();
}

/* ── Node ─────────────────────────────────────────────────────────────────── */

extern "C" esp_matter_node_t *esp_matter_wrapper_node_create(
    esp_matter_attr_callback_t     attr_cb,
    esp_matter_identify_callback_t identify_cb,
    void                          *priv_data)
{
    node::config_t node_cfg;
    auto *attr_cpp  = reinterpret_cast<attribute::callback_t>(attr_cb);
    auto *ident_cpp = reinterpret_cast<identification::callback_t>(identify_cb);
    return node::create(&node_cfg, attr_cpp, ident_cpp, priv_data);
}

/* ── Endpoint ─────────────────────────────────────────────────────────────── */

extern "C" esp_matter_endpoint_t *esp_matter_wrapper_endpoint_create(
    esp_matter_node_t *node,
    uint8_t            flags,
    void              *priv_data)
{
    return endpoint::create(node, flags, priv_data);
}

extern "C" esp_err_t esp_matter_wrapper_endpoint_destroy(
    esp_matter_node_t    *node,
    esp_matter_endpoint_t *ep)
{
    return endpoint::destroy(node, ep);
}

extern "C" uint16_t esp_matter_wrapper_endpoint_get_id(
    esp_matter_endpoint_t *ep)
{
    return endpoint::get_id(ep);
}

extern "C" esp_err_t esp_matter_wrapper_endpoint_add_device_type(
    esp_matter_endpoint_t *ep,
    uint32_t               device_type_id,
    uint8_t                version)
{
    return endpoint::add_device_type(ep, device_type_id, version);
}

extern "C" esp_err_t esp_matter_wrapper_endpoint_enable(
    esp_matter_endpoint_t *ep)
{
    return endpoint::enable(ep);
}

/* ── Pre-built device-type endpoints ─────────────────────────────────────── */

extern "C" esp_matter_endpoint_t *esp_matter_wrapper_add_on_off_light(
    esp_matter_node_t *node,
    uint8_t            flags,
    void              *priv_data)
{
    endpoint::on_off_light::config_t cfg;
    return endpoint::on_off_light::create(node, &cfg, flags, priv_data);
}

extern "C" esp_matter_endpoint_t *esp_matter_wrapper_add_on_off_switch(
    esp_matter_node_t *node,
    uint8_t            flags,
    void              *priv_data)
{
    endpoint::on_off_switch::config_t cfg;
    return endpoint::on_off_switch::create(node, &cfg, flags, priv_data);
}

extern "C" esp_matter_endpoint_t *esp_matter_wrapper_add_dimmable_light(
    esp_matter_node_t *node,
    uint8_t            flags,
    void              *priv_data)
{
    endpoint::dimmable_light::config_t cfg;
    return endpoint::dimmable_light::create(node, &cfg, flags, priv_data);
}

extern "C" esp_matter_endpoint_t *esp_matter_wrapper_add_color_temperature_light(
    esp_matter_node_t *node,
    uint8_t            flags,
    void              *priv_data)
{
    endpoint::color_temperature_light::config_t cfg;
    return endpoint::color_temperature_light::create(node, &cfg, flags, priv_data);
}

/* ── Cluster ──────────────────────────────────────────────────────────────── */

extern "C" esp_matter_cluster_t *esp_matter_wrapper_cluster_create(
    esp_matter_endpoint_t *ep,
    uint32_t               cluster_id,
    uint8_t                flags)
{
    return cluster::create(ep, cluster_id, flags);
}

/* ── Attribute ────────────────────────────────────────────────────────────── */

extern "C" esp_matter_attribute_t *esp_matter_wrapper_attribute_create(
    esp_matter_cluster_t  *cl,
    uint32_t               attribute_id,
    uint16_t               flags,
    esp_matter_attr_val_t  val)
{
    return attribute::create(cl, attribute_id, flags, val);
}

extern "C" esp_err_t esp_matter_wrapper_attribute_update(
    uint16_t               endpoint_id,
    uint32_t               cluster_id,
    uint32_t               attribute_id,
    esp_matter_attr_val_t *val)
{
    return attribute::update(endpoint_id, cluster_id, attribute_id, val);
}

extern "C" esp_err_t esp_matter_wrapper_attribute_get_val(
    esp_matter_attribute_t *attr,
    esp_matter_attr_val_t  *val)
{
    return attribute::get_val(attr, val);
}

extern "C" esp_err_t esp_matter_wrapper_attribute_set_val(
    esp_matter_attribute_t *attr,
    esp_matter_attr_val_t  *val)
{
    return attribute::set_val(attr, val);
}
