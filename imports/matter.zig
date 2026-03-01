//! ESP Matter wrapper — Zig interface to the CHIP/Matter C++ SDK via matter_stubs.h.
//!
//! Requires the `espressif/esp_matter` managed component.
//! To add it: `idf.py add-dependency espressif/esp_matter`

const sys = @import("sys");
const errors = @import("error");

// ── Re-export core types ─────────────────────────────────────────────────────

pub const Node = sys.esp_matter_node_t;
pub const Endpoint = sys.esp_matter_endpoint_t;
pub const Cluster = sys.esp_matter_cluster_t;
pub const Attribute = sys.esp_matter_attribute_t;

/// Endpoint creation flags.
pub const EpFlags = enum(u8) {
    none        = sys.ESP_MATTER_EP_FLAG_NONE,
    destroyable = sys.ESP_MATTER_EP_FLAG_DESTROYABLE,
    bridge      = sys.ESP_MATTER_EP_FLAG_BRIDGE,
};

/// Attribute value types.
pub const ValType = sys.esp_matter_val_type_t;

/// Attribute value (union mirroring esp_matter_val_t).
pub const Val = sys.esp_matter_val_t;

/// Attribute value with type tag.
pub const AttrVal = sys.esp_matter_attr_val_t;

/// Attribute update callback type.
pub const AttrCbType = sys.esp_matter_attr_cb_type_t;

/// Attribute update callback signature.
pub const AttrCallback = sys.esp_matter_attr_callback_t;

/// Identify cluster callback type.
pub const IdentifyCbType = sys.esp_matter_identify_cb_type_t;

/// Identify cluster callback signature.
pub const IdentifyCallback = sys.esp_matter_identify_callback_t;

// ── Attribute value helpers ──────────────────────────────────────────────────

/// Convenience wrappers matching esp_matter_val_bool(), esp_matter_uint8(), etc.
pub const val = struct {
    pub fn boolean(b: bool) AttrVal {
        return sys.esp_matter_val_bool(b);
    }
    pub fn uint8(v: u8) AttrVal {
        return sys.esp_matter_val_uint8(v);
    }
    pub fn uint16(v: u16) AttrVal {
        return sys.esp_matter_val_uint16(v);
    }
    pub fn uint32(v: u32) AttrVal {
        return sys.esp_matter_val_uint32(v);
    }
    pub fn int16(v: i16) AttrVal {
        return sys.esp_matter_val_int16(v);
    }
    pub fn nullable() AttrVal {
        return sys.esp_matter_val_nullable();
    }
};

// ── Core ─────────────────────────────────────────────────────────────────────

/// Start the Matter stack (non-blocking; spawns Matter OS task).
/// Call after building the node + endpoint + cluster data model.
pub fn start(
    attr_cb: ?AttrCallback,
    identify_cb: ?IdentifyCallback,
) !void {
    try errors.espCheckError(sys.esp_matter_wrapper_start(attr_cb, identify_cb));
}

/// Erase Matter NVS data and reboot. Non-recoverable.
pub fn factoryReset() !void {
    try errors.espCheckError(sys.esp_matter_wrapper_factory_reset());
}

/// Return true if Matter has been started.
pub fn isStarted() bool {
    return sys.esp_matter_wrapper_is_started();
}

// ── Node ─────────────────────────────────────────────────────────────────────

/// Create the root Matter node (endpoint 0, Root Node device type).
/// attr_cb fires on every attribute read/write; identify_cb fires on Identify requests.
/// priv_data is forwarded to both callbacks.
pub fn nodeCreate(
    attr_cb: ?AttrCallback,
    identify_cb: ?IdentifyCallback,
    priv_data: ?*anyopaque,
) !*Node {
    const n = sys.esp_matter_wrapper_node_create(attr_cb, identify_cb, priv_data);
    if (n == 0) return error.MatterNodeCreateFailed;
    return @ptrFromInt(n);
}

// ── Endpoint ─────────────────────────────────────────────────────────────────

/// Endpoint operations.
pub const endpoint = struct {
    /// Create a generic endpoint on the node.
    pub fn create(node: *Node, flags: u8, priv_data: ?*anyopaque) !*Endpoint {
        const ep = sys.esp_matter_wrapper_endpoint_create(node, flags, priv_data);
        if (ep == 0) return error.MatterEndpointCreateFailed;
        return @ptrFromInt(ep);
    }

    /// Destroy a destroyable endpoint.
    pub fn destroy(node: *Node, ep: *Endpoint) !void {
        try errors.espCheckError(sys.esp_matter_wrapper_endpoint_destroy(node, ep));
    }

    /// Return the endpoint's numeric ID.
    pub fn getId(ep: *Endpoint) u16 {
        return sys.esp_matter_wrapper_endpoint_get_id(ep);
    }

    /// Associate a Matter device type with this endpoint.
    pub fn addDeviceType(ep: *Endpoint, device_type_id: u32, version: u8) !void {
        try errors.espCheckError(
            sys.esp_matter_wrapper_endpoint_add_device_type(ep, device_type_id, version),
        );
    }

    /// Enable a dynamically-created endpoint (only after Matter is started).
    pub fn enable(ep: *Endpoint) !void {
        try errors.espCheckError(sys.esp_matter_wrapper_endpoint_enable(ep));
    }

    // ── Pre-built device-type helpers ─────────────────────────────────────

    /// Add an On/Off Light endpoint (device type 0x0100).
    pub fn addOnOffLight(node: *Node, flags: u8, priv_data: ?*anyopaque) !*Endpoint {
        const ep = sys.esp_matter_wrapper_add_on_off_light(node, flags, priv_data);
        if (ep == 0) return error.MatterEndpointCreateFailed;
        return @ptrFromInt(ep);
    }

    /// Add an On/Off Switch endpoint (device type 0x0103).
    pub fn addOnOffSwitch(node: *Node, flags: u8, priv_data: ?*anyopaque) !*Endpoint {
        const ep = sys.esp_matter_wrapper_add_on_off_switch(node, flags, priv_data);
        if (ep == 0) return error.MatterEndpointCreateFailed;
        return @ptrFromInt(ep);
    }

    /// Add a Dimmable Light endpoint (device type 0x0101).
    pub fn addDimmableLight(node: *Node, flags: u8, priv_data: ?*anyopaque) !*Endpoint {
        const ep = sys.esp_matter_wrapper_add_dimmable_light(node, flags, priv_data);
        if (ep == 0) return error.MatterEndpointCreateFailed;
        return @ptrFromInt(ep);
    }

    /// Add a Color Temperature Light endpoint (device type 0x010C).
    pub fn addColorTemperatureLight(node: *Node, flags: u8, priv_data: ?*anyopaque) !*Endpoint {
        const ep = sys.esp_matter_wrapper_add_color_temperature_light(node, flags, priv_data);
        if (ep == 0) return error.MatterEndpointCreateFailed;
        return @ptrFromInt(ep);
    }
};

// ── Cluster ───────────────────────────────────────────────────────────────────

/// Cluster operations.
pub const cluster = struct {
    /// Cluster flag: server cluster.
    pub const FLAG_SERVER: u8 = 0x40;
    /// Cluster flag: client cluster.
    pub const FLAG_CLIENT: u8 = 0x80;

    /// Create a cluster on an endpoint.
    pub fn create(ep: *Endpoint, cluster_id: u32, flags: u8) !*Cluster {
        const cl = sys.esp_matter_wrapper_cluster_create(ep, cluster_id, flags);
        if (cl == 0) return error.MatterClusterCreateFailed;
        return @ptrFromInt(cl);
    }
};

// ── Attribute ─────────────────────────────────────────────────────────────────

/// Attribute operations.
pub const attribute = struct {
    /// Create an attribute on a cluster with a default value.
    pub fn create(cl: *Cluster, attribute_id: u32, flags: u16, default_val: AttrVal) !*Attribute {
        const attr = sys.esp_matter_wrapper_attribute_create(cl, attribute_id, flags, default_val);
        if (attr == 0) return error.MatterAttributeCreateFailed;
        return @ptrFromInt(attr);
    }

    /// Update an attribute value (use after Matter is started).
    pub fn update(endpoint_id: u16, cluster_id: u32, attribute_id: u32, v: *AttrVal) !void {
        try errors.espCheckError(
            sys.esp_matter_wrapper_attribute_update(endpoint_id, cluster_id, attribute_id, v),
        );
    }

    /// Get the current value of an attribute.
    pub fn getVal(attr: *Attribute, v: *AttrVal) !void {
        try errors.espCheckError(sys.esp_matter_wrapper_attribute_get_val(attr, v));
    }

    /// Set an attribute value (use before Matter is started).
    pub fn setVal(attr: *Attribute, v: *AttrVal) !void {
        try errors.espCheckError(sys.esp_matter_wrapper_attribute_set_val(attr, v));
    }
};
