const sys = @import("sys");
const errors = @import("error");

// ─────────────────────────────────────────────────────────────────────────────
// Re-exported types
// ─────────────────────────────────────────────────────────────────────────────
pub const Handle = sys.esp_mqtt_client_handle_t;
pub const EventId = sys.esp_mqtt_event_id_t;
pub const Event = sys.esp_mqtt_event_t;
pub const EventHandle = sys.esp_mqtt_event_handle_t;
pub const EventHandler = sys.esp_event_handler_t;
pub const ClientConfig = sys.esp_mqtt_client_config_t;
pub const Topic = sys.esp_mqtt_topic_t;
pub const ErrorCodes = sys.esp_mqtt_error_codes_t;
pub const ErrorType = sys.esp_mqtt_error_type_t;
pub const Transport = sys.esp_mqtt_transport_t;
pub const ProtocolVersion = sys.esp_mqtt_protocol_ver_t;
pub const ConnectReturnCode = sys.esp_mqtt_connect_return_code_t;

// MQTT v5
pub const Handle5 = sys.esp_mqtt5_client_handle_t;
pub const ErrorReasonCode5 = sys.mqtt5_error_reason_code;
pub const UserPropertyHandle5 = sys.mqtt5_user_property_handle_t;
pub const UserPropertyItem5 = sys.esp_mqtt5_user_property_item_t;
pub const ConnectionProperty5 = sys.esp_mqtt5_connection_property_config_t;
pub const PublishProperty5 = sys.esp_mqtt5_publish_property_config_t;
pub const SubscribeProperty5 = sys.esp_mqtt5_subscribe_property_config_t;
pub const UnsubscribeProperty5 = sys.esp_mqtt5_unsubscribe_property_config_t;
pub const DisconnectProperty5 = sys.esp_mqtt5_disconnect_property_config_t;
pub const EventProperty5 = sys.esp_mqtt5_event_property_t;

// ─────────────────────────────────────────────────────────────────────────────
// Errors
// ─────────────────────────────────────────────────────────────────────────────
pub const Error = error{
    /// publish / subscribe / enqueue returned -1 (queuing failed)
    Failed,
    /// publish returned -2 (outbox full)
    OutboxFull,
};

/// Converts a message-id return value (≥0 = ok, -1 = failed, -2 = outbox full)
/// into `!u32`.
fn msgIdResult(rc: c_int) Error!u32 {
    return switch (rc) {
        -2 => error.OutboxFull,
        -1 => error.Failed,
        else => @intCast(rc),
    };
}

// ─────────────────────────────────────────────────────────────────────────────
// Client lifecycle
// ─────────────────────────────────────────────────────────────────────────────

/// Initialise a new MQTT client.  Returns `null` if allocation fails.
pub fn init(cfg: *const ClientConfig) ?Handle {
    return sys.esp_mqtt_client_init(cfg);
}

pub fn deinit(client: Handle) !void {
    return errors.espCheckError(sys.esp_mqtt_client_destroy(client));
}

pub fn setConfig(client: Handle, cfg: *const ClientConfig) !void {
    return errors.espCheckError(sys.esp_mqtt_set_config(client, cfg));
}

pub fn setUri(client: Handle, uri: [:0]const u8) !void {
    return errors.espCheckError(sys.esp_mqtt_client_set_uri(client, uri.ptr));
}

// ─────────────────────────────────────────────────────────────────────────────
// Connection control
// ─────────────────────────────────────────────────────────────────────────────

pub fn start(client: Handle) !void {
    return errors.espCheckError(sys.esp_mqtt_client_start(client));
}

pub fn stop(client: Handle) !void {
    return errors.espCheckError(sys.esp_mqtt_client_stop(client));
}

pub fn reconnect(client: Handle) !void {
    return errors.espCheckError(sys.esp_mqtt_client_reconnect(client));
}

pub fn disconnect(client: Handle) !void {
    return errors.espCheckError(sys.esp_mqtt_client_disconnect(client));
}

// ─────────────────────────────────────────────────────────────────────────────
// Publish
// ─────────────────────────────────────────────────────────────────────────────

pub const PublishConfig = struct {
    qos: u2 = 0,
    retain: bool = false,
};

/// Publish `data` to `topic`.  Returns the message-id assigned by the broker.
pub fn publish(client: Handle, topic: [:0]const u8, data: []const u8, cfg: PublishConfig) Error!u32 {
    return msgIdResult(sys.esp_mqtt_client_publish(
        client,
        topic.ptr,
        data.ptr,
        @intCast(data.len),
        @intCast(cfg.qos),
        @intFromBool(cfg.retain),
    ));
}

pub const EnqueueConfig = struct {
    qos: u2 = 0,
    retain: bool = false,
    /// Store in outbox even when disconnected.
    store: bool = true,
};

/// Enqueue a publish for delivery (stores in outbox when disconnected).
pub fn enqueue(client: Handle, topic: [:0]const u8, data: []const u8, cfg: EnqueueConfig) Error!u32 {
    return msgIdResult(sys.esp_mqtt_client_enqueue(
        client,
        topic.ptr,
        data.ptr,
        @intCast(data.len),
        @intCast(cfg.qos),
        @intFromBool(cfg.retain),
        cfg.store,
    ));
}

// ─────────────────────────────────────────────────────────────────────────────
// Subscribe / Unsubscribe
// ─────────────────────────────────────────────────────────────────────────────

/// Subscribe to a single topic filter.  Returns the message-id.
pub fn subscribe(client: Handle, topic: [:0]const u8, qos: u2) Error!u32 {
    return msgIdResult(sys.esp_mqtt_client_subscribe_single(client, topic.ptr, @intCast(qos)));
}

/// Subscribe to multiple topic filters in one call.
pub fn subscribeMultiple(client: Handle, topics: []const Topic) Error!u32 {
    return msgIdResult(sys.esp_mqtt_client_subscribe_multiple(
        client,
        topics.ptr,
        @intCast(topics.len),
    ));
}

pub fn unsubscribe(client: Handle, topic: [:0]const u8) Error!u32 {
    return msgIdResult(sys.esp_mqtt_client_unsubscribe(client, topic.ptr));
}

// ─────────────────────────────────────────────────────────────────────────────
// Event registration
// ─────────────────────────────────────────────────────────────────────────────

pub fn registerEvent(client: Handle, event: EventId, handler: EventHandler, arg: ?*anyopaque) !void {
    return errors.espCheckError(sys.esp_mqtt_client_register_event(client, event, handler, arg));
}

pub fn unregisterEvent(client: Handle, event: EventId, handler: EventHandler) !void {
    return errors.espCheckError(sys.esp_mqtt_client_unregister_event(client, event, handler));
}

// ─────────────────────────────────────────────────────────────────────────────
// Diagnostics
// ─────────────────────────────────────────────────────────────────────────────

/// Returns the current outbox size in bytes.
pub fn getOutboxSize(client: Handle) usize {
    return @intCast(sys.esp_mqtt_client_get_outbox_size(client));
}

/// Dispatch a custom application event through the MQTT event loop.
pub fn dispatchCustomEvent(client: Handle, event: *Event) !void {
    return errors.espCheckError(sys.esp_mqtt_dispatch_custom_event(client, event));
}

// ─────────────────────────────────────────────────────────────────────────────
// MQTT v5 extensions
// ─────────────────────────────────────────────────────────────────────────────

pub const v5 = struct {
    pub fn setConnectProperty(client: Handle5, prop: *const ConnectionProperty5) !void {
        return errors.espCheckError(sys.esp_mqtt5_client_set_connect_property(client, prop));
    }

    pub fn setPublishProperty(client: Handle5, prop: *const PublishProperty5) !void {
        return errors.espCheckError(sys.esp_mqtt5_client_set_publish_property(client, prop));
    }

    pub fn setSubscribeProperty(client: Handle5, prop: *const SubscribeProperty5) !void {
        return errors.espCheckError(sys.esp_mqtt5_client_set_subscribe_property(client, prop));
    }

    pub fn setUnsubscribeProperty(client: Handle5, prop: *const UnsubscribeProperty5) !void {
        return errors.espCheckError(sys.esp_mqtt5_client_set_unsubscribe_property(client, prop));
    }

    pub fn setDisconnectProperty(client: Handle5, prop: *const DisconnectProperty5) !void {
        return errors.espCheckError(sys.esp_mqtt5_client_set_disconnect_property(client, prop));
    }

    // ── User properties ───────────────────────────────────────────────────

    pub fn setUserProperty(handle: *UserPropertyHandle5, items: []UserPropertyItem5) !void {
        return errors.espCheckError(sys.esp_mqtt5_client_set_user_property(
            handle,
            items.ptr,
            @intCast(items.len),
        ));
    }

    /// Returns how many user-property items are present.
    pub fn getUserPropertyCount(handle: UserPropertyHandle5) u8 {
        return sys.esp_mqtt5_client_get_user_property_count(handle);
    }

    /// Read user-property items into the caller-supplied slice.
    /// The slice length must be ≥ `getUserPropertyCount()`.
    pub fn getUserProperty(handle: UserPropertyHandle5, out: []UserPropertyItem5) !void {
        var count: u8 = @intCast(out.len);
        return errors.espCheckError(sys.esp_mqtt5_client_get_user_property(
            handle,
            out.ptr,
            &count,
        ));
    }

    pub fn deleteUserProperty(handle: UserPropertyHandle5) void {
        sys.esp_mqtt5_client_delete_user_property(handle);
    }
};
