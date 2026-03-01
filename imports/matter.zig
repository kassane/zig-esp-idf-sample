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
    none = sys.ESP_MATTER_EP_FLAG_NONE,
    destroyable = sys.ESP_MATTER_EP_FLAG_DESTROYABLE,
    bridge = sys.ESP_MATTER_EP_FLAG_BRIDGE,
};

/// Attribute value types (Zig enum wrapping the C enum constants).
pub const ValType = enum(c_uint) {
    invalid = sys.ESP_MATTER_VAL_TYPE_INVALID,
    boolean = sys.ESP_MATTER_VAL_TYPE_BOOLEAN,
    integer = sys.ESP_MATTER_VAL_TYPE_INTEGER,
    float_ = sys.ESP_MATTER_VAL_TYPE_FLOAT,
    array = sys.ESP_MATTER_VAL_TYPE_ARRAY,
    char_string = sys.ESP_MATTER_VAL_TYPE_CHAR_STRING,
    octet_string = sys.ESP_MATTER_VAL_TYPE_OCTET_STRING,
    int8 = sys.ESP_MATTER_VAL_TYPE_INT8,
    uint8 = sys.ESP_MATTER_VAL_TYPE_UINT8,
    int16 = sys.ESP_MATTER_VAL_TYPE_INT16,
    uint16 = sys.ESP_MATTER_VAL_TYPE_UINT16,
    int32 = sys.ESP_MATTER_VAL_TYPE_INT32,
    uint32 = sys.ESP_MATTER_VAL_TYPE_UINT32,
    int64 = sys.ESP_MATTER_VAL_TYPE_INT64,
    uint64 = sys.ESP_MATTER_VAL_TYPE_UINT64,
    enum8 = sys.ESP_MATTER_VAL_TYPE_ENUM8,
    bitmap8 = sys.ESP_MATTER_VAL_TYPE_BITMAP8,
    bitmap16 = sys.ESP_MATTER_VAL_TYPE_BITMAP16,
    bitmap32 = sys.ESP_MATTER_VAL_TYPE_BITMAP32,
    enum16 = sys.ESP_MATTER_VAL_TYPE_ENUM16,
    long_char_string = sys.ESP_MATTER_VAL_TYPE_LONG_CHAR_STRING,
    long_octet_string = sys.ESP_MATTER_VAL_TYPE_LONG_OCTET_STRING,
    _,
};

/// Attribute value (union mirroring esp_matter_val_t).
pub const Val = sys.esp_matter_val_t;

/// Attribute value with type tag.
pub const AttrVal = sys.esp_matter_attr_val_t;

/// Attribute update callback type (Zig enum with named members).
/// Use e.g. `matter.AttrCbType.ESP_MATTER_ATTR_CB_POST_UPDATE`.
pub const AttrCbType = enum(c_uint) {
    ESP_MATTER_ATTR_CB_PRE_UPDATE = sys.ESP_MATTER_ATTR_CB_PRE_UPDATE,
    ESP_MATTER_ATTR_CB_POST_UPDATE = sys.ESP_MATTER_ATTR_CB_POST_UPDATE,
    ESP_MATTER_ATTR_CB_READ = sys.ESP_MATTER_ATTR_CB_READ,
    ESP_MATTER_ATTR_CB_WRITE = sys.ESP_MATTER_ATTR_CB_WRITE,
    _,
};

/// Attribute update callback function pointer type.
/// The callback receives a `?*AttrVal` which at the C ABI boundary is `[*c]AttrVal`.
/// Return 0 (ESP_OK) to allow, non-zero from PRE_UPDATE to block.
pub const AttrCallback = ?*const fn (
    AttrCbType,
    u16,
    u32,
    u32,
    ?*AttrVal,
    ?*anyopaque,
) callconv(.c) c_int;

/// Identify cluster callback type.
pub const IdentifyCbType = enum(c_uint) {
    ESP_MATTER_IDENTIFY_CB_START = sys.ESP_MATTER_IDENTIFY_CB_START,
    ESP_MATTER_IDENTIFY_CB_STOP = sys.ESP_MATTER_IDENTIFY_CB_STOP,
    ESP_MATTER_IDENTIFY_CB_EFFECT = sys.ESP_MATTER_IDENTIFY_CB_EFFECT,
    _,
};

/// Identify cluster callback function pointer type.
pub const IdentifyCallback = ?*const fn (IdentifyCbType, u16, u8, u8, ?*anyopaque) callconv(.c) c_int;

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
pub fn start(attr_cb: AttrCallback, identify_cb: IdentifyCallback) !void {
    // @ptrCast converts our typed function pointer to the raw sys type.
    // The types are ABI-compatible: enum(c_uint)↔c_uint, ?*T↔[*c]T.
    try errors.espCheckError(sys.esp_matter_wrapper_start(@ptrCast(attr_cb), @ptrCast(identify_cb)));
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
pub fn nodeCreate(attr_cb: AttrCallback, identify_cb: IdentifyCallback, priv_data: ?*anyopaque) !*Node {
    const n = sys.esp_matter_wrapper_node_create(@ptrCast(attr_cb), @ptrCast(identify_cb), priv_data);
    if (n == null) return error.MatterNodeCreateFailed;
    return @ptrCast(n);
}

// ── Endpoint ─────────────────────────────────────────────────────────────────

/// Endpoint operations.
pub const endpoint = struct {
    /// Create a generic endpoint on the node.
    pub fn create(node: *Node, flags: EpFlags, priv_data: ?*anyopaque) !*Endpoint {
        const ep = sys.esp_matter_wrapper_endpoint_create(node, @intFromEnum(flags), priv_data);
        if (ep == null) return error.MatterEndpointCreateFailed;
        return @ptrCast(ep);
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
    pub fn addOnOffLight(node: *Node, flags: EpFlags, priv_data: ?*anyopaque) !*Endpoint {
        const ep = sys.esp_matter_wrapper_add_on_off_light(node, @intFromEnum(flags), priv_data);
        if (ep == null) return error.MatterEndpointCreateFailed;
        return @ptrCast(ep);
    }

    /// Add an On/Off Switch endpoint (device type 0x0103).
    pub fn addOnOffSwitch(node: *Node, flags: EpFlags, priv_data: ?*anyopaque) !*Endpoint {
        const ep = sys.esp_matter_wrapper_add_on_off_switch(node, @intFromEnum(flags), priv_data);
        if (ep == null) return error.MatterEndpointCreateFailed;
        return @ptrCast(ep);
    }

    /// Add a Dimmable Light endpoint (device type 0x0101).
    pub fn addDimmableLight(node: *Node, flags: EpFlags, priv_data: ?*anyopaque) !*Endpoint {
        const ep = sys.esp_matter_wrapper_add_dimmable_light(node, @intFromEnum(flags), priv_data);
        if (ep == null) return error.MatterEndpointCreateFailed;
        return @ptrCast(ep);
    }

    /// Add a Color Temperature Light endpoint (device type 0x010C).
    pub fn addColorTemperatureLight(node: *Node, flags: EpFlags, priv_data: ?*anyopaque) !*Endpoint {
        const ep = sys.esp_matter_wrapper_add_color_temperature_light(node, @intFromEnum(flags), priv_data);
        if (ep == null) return error.MatterEndpointCreateFailed;
        return @ptrCast(ep);
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
        if (cl == null) return error.MatterClusterCreateFailed;
        return @ptrCast(cl);
    }
};

// ── Attribute ─────────────────────────────────────────────────────────────────

/// Attribute operations.
pub const attribute = struct {
    /// Create an attribute on a cluster with a default value.
    pub fn create(cl: *Cluster, attribute_id: u32, flags: u16, default_val: AttrVal) !*Attribute {
        const attr = sys.esp_matter_wrapper_attribute_create(cl, attribute_id, flags, default_val);
        if (attr == null) return error.MatterAttributeCreateFailed;
        return @ptrCast(attr);
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
