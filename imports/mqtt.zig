const std = @import("std");
const sys = @import("sys");

pub const esp_transport_keepalive = extern struct {
    keep_alive_enable: bool = std.mem.zeroes(bool),
    keep_alive_idle: c_int = std.mem.zeroes(c_int),
    keep_alive_interval: c_int = std.mem.zeroes(c_int),
    keep_alive_count: c_int = std.mem.zeroes(c_int),
};
pub const esp_transport_keep_alive_t = esp_transport_keepalive;
pub const esp_transport_list_t = opaque {};
pub const esp_transport_list_handle_t = ?*esp_transport_list_t;
pub const esp_transport_item_t = opaque {};
pub const esp_transport_handle_t = ?*esp_transport_item_t;
pub const connect_func = ?*const fn (esp_transport_handle_t, [*:0]const u8, c_int, c_int) callconv(.C) c_int;
pub const io_func = ?*const fn (esp_transport_handle_t, [*:0]const u8, c_int, c_int) callconv(.C) c_int;
pub const io_read_func = ?*const fn (esp_transport_handle_t, [*:0]u8, c_int, c_int) callconv(.C) c_int;
pub const trans_func = ?*const fn (esp_transport_handle_t) callconv(.C) c_int;
pub const poll_func = ?*const fn (esp_transport_handle_t, c_int) callconv(.C) c_int;
pub const connect_async_func = ?*const fn (esp_transport_handle_t, [*:0]const u8, c_int, c_int) callconv(.C) c_int;
pub const payload_transfer_func = ?*const fn (esp_transport_handle_t) callconv(.C) esp_transport_handle_t;
pub const esp_tls_last_error = opaque {};
pub const esp_tls_error_handle_t = ?*esp_tls_last_error;
pub const esp_tcp_transport_err_t = enum(c_int) {
    ERR_TCP_TRANSPORT_NO_MEM = -3,
    ERR_TCP_TRANSPORT_CONNECTION_FAILED = -2,
    ERR_TCP_TRANSPORT_CONNECTION_CLOSED_BY_FIN = -1,
    ERR_TCP_TRANSPORT_CONNECTION_TIMEOUT = 0,
};
pub extern fn esp_transport_list_init() esp_transport_list_handle_t;
pub extern fn esp_transport_list_destroy(list: esp_transport_list_handle_t) sys.esp_err_t;
pub extern fn esp_transport_list_add(list: esp_transport_list_handle_t, t: esp_transport_handle_t, scheme: [*:0]const u8) sys.esp_err_t;
pub extern fn esp_transport_list_clean(list: esp_transport_list_handle_t) sys.esp_err_t;
pub extern fn esp_transport_list_get_transport(list: esp_transport_list_handle_t, scheme: [*:0]const u8) esp_transport_handle_t;
pub extern fn esp_transport_init() esp_transport_handle_t;
pub extern fn esp_transport_destroy(t: esp_transport_handle_t) sys.esp_err_t;
pub extern fn esp_transport_get_default_port(t: esp_transport_handle_t) c_int;
pub extern fn esp_transport_set_default_port(t: esp_transport_handle_t, port: c_int) sys.esp_err_t;
pub extern fn esp_transport_connect(t: esp_transport_handle_t, host: [*:0]const u8, port: c_int, timeout_ms: c_int) c_int;
pub extern fn esp_transport_connect_async(t: esp_transport_handle_t, host: [*:0]const u8, port: c_int, timeout_ms: c_int) c_int;
pub extern fn esp_transport_read(t: esp_transport_handle_t, buffer: [*:0]u8, len: c_int, timeout_ms: c_int) c_int;
pub extern fn esp_transport_poll_read(t: esp_transport_handle_t, timeout_ms: c_int) c_int;
pub extern fn esp_transport_write(t: esp_transport_handle_t, buffer: [*:0]const u8, len: c_int, timeout_ms: c_int) c_int;
pub extern fn esp_transport_poll_write(t: esp_transport_handle_t, timeout_ms: c_int) c_int;
pub extern fn esp_transport_close(t: esp_transport_handle_t) c_int;
pub extern fn esp_transport_get_context_data(t: esp_transport_handle_t) ?*anyopaque;
pub extern fn esp_transport_get_payload_transport_handle(t: esp_transport_handle_t) esp_transport_handle_t;
pub extern fn esp_transport_set_context_data(t: esp_transport_handle_t, data: ?*anyopaque) sys.esp_err_t;
pub extern fn esp_transport_set_func(t: esp_transport_handle_t, _connect: connect_func, _read: io_read_func, _write: io_func, _close: trans_func, _poll_read: poll_func, _poll_write: poll_func, _destroy: trans_func) sys.esp_err_t;
pub extern fn esp_transport_set_async_connect_func(t: esp_transport_handle_t, _connect_async_func: connect_async_func) sys.esp_err_t;
pub extern fn esp_transport_set_parent_transport_func(t: esp_transport_handle_t, _parent_transport: payload_transfer_func) sys.esp_err_t;
pub extern fn esp_transport_get_error_handle(t: esp_transport_handle_t) esp_tls_error_handle_t;
pub extern fn esp_transport_get_errno(t: esp_transport_handle_t) c_int;
pub extern fn esp_transport_translate_error(@"error": esp_tcp_transport_err_t) sys.esp_err_t;
pub const esp_mqtt_client = opaque {};
pub const esp_mqtt_client_handle_t = ?*esp_mqtt_client;
pub const esp_mqtt_event_id_t = enum(c_int) {
    MQTT_EVENT_ANY = -1,
    MQTT_EVENT_ERROR = 0,
    MQTT_EVENT_CONNECTED = 1,
    MQTT_EVENT_DISCONNECTED = 2,
    MQTT_EVENT_SUBSCRIBED = 3,
    MQTT_EVENT_UNSUBSCRIBED = 4,
    MQTT_EVENT_PUBLISHED = 5,
    MQTT_EVENT_DATA = 6,
    MQTT_EVENT_BEFORE_CONNECT = 7,
    MQTT_EVENT_DELETED = 8,
    MQTT_USER_EVENT = 9,
};
pub const esp_mqtt_connect_return_code_t = enum(c_uint) {
    MQTT_CONNECTION_ACCEPTED = 0,
    MQTT_CONNECTION_REFUSE_PROTOCOL = 1,
    MQTT_CONNECTION_REFUSE_ID_REJECTED = 2,
    MQTT_CONNECTION_REFUSE_SERVER_UNAVAILABLE = 3,
    MQTT_CONNECTION_REFUSE_BAD_USERNAME = 4,
    MQTT_CONNECTION_REFUSE_NOT_AUTHORIZED = 5,
};
pub const esp_mqtt_error_type_t = enum(c_uint) {
    MQTT_ERROR_TYPE_NONE = 0,
    MQTT_ERROR_TYPE_TCP_TRANSPORT = 1,
    MQTT_ERROR_TYPE_CONNECTION_REFUSED = 2,
    MQTT_ERROR_TYPE_SUBSCRIBE_FAILED = 3,
};
pub const esp_mqtt_transport_t = enum(c_uint) {
    MQTT_TRANSPORT_UNKNOWN = 0,
    MQTT_TRANSPORT_OVER_TCP = 1,
    MQTT_TRANSPORT_OVER_SSL = 2,
    MQTT_TRANSPORT_OVER_WS = 3,
    MQTT_TRANSPORT_OVER_WSS = 4,
};
pub const esp_mqtt_protocol_ver_t = enum(c_uint) {
    MQTT_PROTOCOL_UNDEFINED = 0,
    MQTT_PROTOCOL_V_3_1 = 1,
    MQTT_PROTOCOL_V_3_1_1 = 2,
    MQTT_PROTOCOL_V_5 = 3,
};
pub const esp_mqtt_error_codes = extern struct {
    esp_tls_last_esp_err: sys.esp_err_t = std.mem.zeroes(sys.esp_err_t),
    esp_tls_stack_err: c_int = std.mem.zeroes(c_int),
    esp_tls_cert_verify_flags: c_int = std.mem.zeroes(c_int),
    error_type: esp_mqtt_error_type_t = .MQTT_ERROR_TYPE_NONE,
    connect_return_code: esp_mqtt_connect_return_code_t = std.mem.zeroes(esp_mqtt_connect_return_code_t),
    esp_transport_sock_errno: c_int = std.mem.zeroes(c_int),
};
pub const esp_mqtt_error_codes_t = esp_mqtt_error_codes;
pub const esp_mqtt_event_t = extern struct {
    event_id: esp_mqtt_event_id_t = std.mem.zeroes(esp_mqtt_event_id_t),
    client: esp_mqtt_client_handle_t = std.mem.zeroes(esp_mqtt_client_handle_t),
    data: [*:0]u8 = std.mem.zeroes([*:0]u8),
    data_len: c_int = std.mem.zeroes(c_int),
    total_data_len: c_int = std.mem.zeroes(c_int),
    current_data_offset: c_int = std.mem.zeroes(c_int),
    topic: [*:0]u8 = std.mem.zeroes([*:0]u8),
    topic_len: c_int = std.mem.zeroes(c_int),
    msg_id: c_int = std.mem.zeroes(c_int),
    session_present: c_int = std.mem.zeroes(c_int),
    error_handle: [*c]esp_mqtt_error_codes_t = std.mem.zeroes([*c]esp_mqtt_error_codes_t),
    retain: bool = std.mem.zeroes(bool),
    qos: c_int = std.mem.zeroes(c_int),
    dup: bool = std.mem.zeroes(bool),
    protocol_ver: esp_mqtt_protocol_ver_t = std.mem.zeroes(esp_mqtt_protocol_ver_t),
};
pub const esp_mqtt_event_handle_t = [*c]esp_mqtt_event_t;
pub const address_t_5 = extern struct {
    uri: [*:0]const u8 = "",
    hostname: [*:0]const u8 = "",
    transport: esp_mqtt_transport_t = std.mem.zeroes(esp_mqtt_transport_t),
    path: [*:0]const u8 = "",
    port: u32 = std.mem.zeroes(u32),
};
pub const psk_key_hint_7 = opaque {};
pub const verification_t_6 = extern struct {
    use_global_ca_store: bool = false,
    crt_bundle_attach: ?*const fn (?*anyopaque) callconv(.C) sys.esp_err_t = null,
    certificate: [*:0]const u8 = "",
    certificate_len: usize = std.mem.zeroes(usize),
    psk_hint_key: ?*const psk_key_hint_7 = std.mem.zeroes(?*const psk_key_hint_7),
    skip_cert_common_name_check: bool = std.mem.zeroes(bool),
    alpn_protos: [*c][*c]const u8 = std.mem.zeroes([*c][*c]const u8),
    common_name: [*:0]const u8 = "",
};
pub const broker_t_4 = extern struct {
    address: address_t_5 = std.mem.zeroes(address_t_5),
    verification: verification_t_6 = std.mem.zeroes(verification_t_6),
};
pub const authentication_t_9 = extern struct {
    password: [*:0]const u8 = "",
    certificate: [*:0]const u8 = "",
    certificate_len: usize = std.mem.zeroes(usize),
    key: [*:0]const u8 = "",
    key_len: usize = std.mem.zeroes(usize),
    key_password: [*:0]const u8 = "",
    key_password_len: c_int = std.mem.zeroes(c_int),
    use_secure_element: bool = std.mem.zeroes(bool),
    ds_data: ?*anyopaque = std.mem.zeroes(?*anyopaque),
};
pub const credentials_t_8 = extern struct {
    username: [*:0]const u8 = "",
    client_id: [*:0]const u8 = "",
    set_null_client_id: bool = std.mem.zeroes(bool),
    authentication: authentication_t_9 = std.mem.zeroes(authentication_t_9),
};
pub const last_will_t_11 = extern struct {
    topic: [*:0]const u8 = "",
    msg: [*:0]const u8 = "",
    msg_len: c_int = std.mem.zeroes(c_int),
    qos: c_int = std.mem.zeroes(c_int),
    retain: c_int = std.mem.zeroes(c_int),
};
pub const session_t_10 = extern struct {
    last_will: last_will_t_11 = std.mem.zeroes(last_will_t_11),
    disable_clean_session: bool = std.mem.zeroes(bool),
    keepalive: c_int = std.mem.zeroes(c_int),
    disable_keepalive: bool = std.mem.zeroes(bool),
    protocol_ver: esp_mqtt_protocol_ver_t = std.mem.zeroes(esp_mqtt_protocol_ver_t),
    message_retransmit_timeout: c_int = std.mem.zeroes(c_int),
};
pub const ifreq_13 = opaque {};
pub const network_t_12 = extern struct {
    reconnect_timeout_ms: c_int = std.mem.zeroes(c_int),
    timeout_ms: c_int = std.mem.zeroes(c_int),
    refresh_connection_after_ms: c_int = std.mem.zeroes(c_int),
    disable_auto_reconnect: bool = std.mem.zeroes(bool),
    transport: esp_transport_handle_t = std.mem.zeroes(esp_transport_handle_t),
    if_name: ?*ifreq_13 = std.mem.zeroes(?*ifreq_13),
};
pub const task_t_14 = extern struct {
    priority: c_int = std.mem.zeroes(c_int),
    stack_size: c_int = std.mem.zeroes(c_int),
};
pub const buffer_t_15 = extern struct {
    size: c_int = std.mem.zeroes(c_int),
    out_size: c_int = std.mem.zeroes(c_int),
};
pub const outbox_config_t_16 = extern struct {
    limit: u64 = std.mem.zeroes(u64),
};
pub const esp_mqtt_client_config_t = extern struct {
    broker: broker_t_4 = std.mem.zeroes(broker_t_4),
    credentials: credentials_t_8 = std.mem.zeroes(credentials_t_8),
    session: session_t_10 = std.mem.zeroes(session_t_10),
    network: network_t_12 = std.mem.zeroes(network_t_12),
    task: task_t_14 = std.mem.zeroes(task_t_14),
    buffer: buffer_t_15 = std.mem.zeroes(buffer_t_15),
    outbox: outbox_config_t_16 = std.mem.zeroes(outbox_config_t_16),
};
pub const topic_t = extern struct {
    filter: [*:0]const u8 = "",
    qos: c_int = std.mem.zeroes(c_int),
};
pub const esp_mqtt_topic_t = topic_t;
pub extern fn esp_mqtt_client_init(config: [*c]const esp_mqtt_client_config_t) esp_mqtt_client_handle_t;
pub extern fn esp_mqtt_client_set_uri(client: esp_mqtt_client_handle_t, uri: [*:0]const u8) sys.esp_err_t;
pub extern fn esp_mqtt_client_start(client: esp_mqtt_client_handle_t) sys.esp_err_t;
pub extern fn esp_mqtt_client_reconnect(client: esp_mqtt_client_handle_t) sys.esp_err_t;
pub extern fn esp_mqtt_client_disconnect(client: esp_mqtt_client_handle_t) sys.esp_err_t;
pub extern fn esp_mqtt_client_stop(client: esp_mqtt_client_handle_t) sys.esp_err_t;
pub extern fn esp_mqtt_client_subscribe_single(client: esp_mqtt_client_handle_t, topic: [*:0]const u8, qos: c_int) c_int;
pub extern fn esp_mqtt_client_subscribe_multiple(client: esp_mqtt_client_handle_t, topic_list: [*c]const esp_mqtt_topic_t, size: c_int) c_int;
pub extern fn esp_mqtt_client_unsubscribe(client: esp_mqtt_client_handle_t, topic: [*:0]const u8) c_int;
pub extern fn esp_mqtt_client_publish(client: esp_mqtt_client_handle_t, topic: [*:0]const u8, data: [*:0]const u8, len: c_int, qos: c_int, retain: c_int) c_int;
pub extern fn esp_mqtt_client_enqueue(client: esp_mqtt_client_handle_t, topic: [*:0]const u8, data: [*:0]const u8, len: c_int, qos: c_int, retain: c_int, store: bool) c_int;
pub extern fn esp_mqtt_client_destroy(client: esp_mqtt_client_handle_t) sys.esp_err_t;
pub extern fn esp_mqtt_set_config(client: esp_mqtt_client_handle_t, config: [*c]const esp_mqtt_client_config_t) sys.esp_err_t;
pub extern fn esp_mqtt_client_register_event(client: esp_mqtt_client_handle_t, event: esp_mqtt_event_id_t, event_handler: sys.esp_event_handler_t, event_handler_arg: ?*anyopaque) sys.esp_err_t;
pub extern fn esp_mqtt_client_unregister_event(client: esp_mqtt_client_handle_t, event: esp_mqtt_event_id_t, event_handler: sys.esp_event_handler_t) sys.esp_err_t;
pub extern fn esp_mqtt_client_get_outbox_size(client: esp_mqtt_client_handle_t) c_int;
pub extern fn esp_mqtt_dispatch_custom_event(client: esp_mqtt_client_handle_t, event: [*c]esp_mqtt_event_t) sys.esp_err_t;
pub const esp_mqtt5_client_handle_t = ?*esp_mqtt_client;
pub const mqtt5_error_reason_code = enum(c_uint) {
    MQTT5_UNSPECIFIED_ERROR = 128,
    MQTT5_MALFORMED_PACKET = 129,
    MQTT5_PROTOCOL_ERROR = 130,
    MQTT5_IMPLEMENT_SPECIFIC_ERROR = 131,
    MQTT5_UNSUPPORTED_PROTOCOL_VER = 132,
    MQTT5_INVAILD_CLIENT_ID = 133,
    MQTT5_INVALID_CLIENT_ID = 133,
    MQTT5_BAD_USERNAME_OR_PWD = 134,
    MQTT5_NOT_AUTHORIZED = 135,
    MQTT5_SERVER_UNAVAILABLE = 136,
    MQTT5_SERVER_BUSY = 137,
    MQTT5_BANNED = 138,
    MQTT5_SERVER_SHUTTING_DOWN = 139,
    MQTT5_BAD_AUTH_METHOD = 140,
    MQTT5_KEEP_ALIVE_TIMEOUT = 141,
    MQTT5_SESSION_TAKEN_OVER = 142,
    MQTT5_TOPIC_FILTER_INVAILD = 143,
    MQTT5_TOPIC_FILTER_INVALID = 143,
    MQTT5_TOPIC_NAME_INVAILD = 144,
    MQTT5_TOPIC_NAME_INVALID = 144,
    MQTT5_PACKET_IDENTIFIER_IN_USE = 145,
    MQTT5_PACKET_IDENTIFIER_NOT_FOUND = 146,
    MQTT5_RECEIVE_MAXIMUM_EXCEEDED = 147,
    MQTT5_TOPIC_ALIAS_INVAILD = 148,
    MQTT5_TOPIC_ALIAS_INVALID = 148,
    MQTT5_PACKET_TOO_LARGE = 149,
    MQTT5_MESSAGE_RATE_TOO_HIGH = 150,
    MQTT5_QUOTA_EXCEEDED = 151,
    MQTT5_ADMINISTRATIVE_ACTION = 152,
    MQTT5_PAYLOAD_FORMAT_INVAILD = 153,
    MQTT5_PAYLOAD_FORMAT_INVALID = 153,
    MQTT5_RETAIN_NOT_SUPPORT = 154,
    MQTT5_QOS_NOT_SUPPORT = 155,
    MQTT5_USE_ANOTHER_SERVER = 156,
    MQTT5_SERVER_MOVED = 157,
    MQTT5_SHARED_SUBSCR_NOT_SUPPORTED = 158,
    MQTT5_CONNECTION_RATE_EXCEEDED = 159,
    MQTT5_MAXIMUM_CONNECT_TIME = 160,
    MQTT5_SUBSCRIBE_IDENTIFIER_NOT_SUPPORT = 161,
    MQTT5_WILDCARD_SUBSCRIBE_NOT_SUPPORT = 162,
};
pub const mqtt5_user_property_list_t = opaque {};
pub const mqtt5_user_property_handle_t = ?*mqtt5_user_property_list_t;
pub const esp_mqtt5_connection_property_config_t = extern struct {
    session_expiry_interval: u32 = std.mem.zeroes(u32),
    maximum_packet_size: u32 = std.mem.zeroes(u32),
    receive_maximum: u16 = std.mem.zeroes(u16),
    topic_alias_maximum: u16 = std.mem.zeroes(u16),
    request_resp_info: bool = std.mem.zeroes(bool),
    request_problem_info: bool = std.mem.zeroes(bool),
    user_property: mqtt5_user_property_handle_t = std.mem.zeroes(mqtt5_user_property_handle_t),
    will_delay_interval: u32 = std.mem.zeroes(u32),
    message_expiry_interval: u32 = std.mem.zeroes(u32),
    payload_format_indicator: bool = std.mem.zeroes(bool),
    content_type: [*:0]const u8 = "",
    response_topic: [*:0]const u8 = "",
    correlation_data: [*:0]const u8 = "",
    correlation_data_len: u16 = std.mem.zeroes(u16),
    will_user_property: mqtt5_user_property_handle_t = std.mem.zeroes(mqtt5_user_property_handle_t),
};
pub const esp_mqtt5_publish_property_config_t = extern struct {
    payload_format_indicator: bool = std.mem.zeroes(bool),
    message_expiry_interval: u32 = std.mem.zeroes(u32),
    topic_alias: u16 = std.mem.zeroes(u16),
    response_topic: [*:0]const u8 = "",
    correlation_data: [*:0]const u8 = "",
    correlation_data_len: u16 = std.mem.zeroes(u16),
    content_type: [*:0]const u8 = "",
    user_property: mqtt5_user_property_handle_t = std.mem.zeroes(mqtt5_user_property_handle_t),
};
pub const esp_mqtt5_subscribe_property_config_t = extern struct {
    subscribe_id: u16 = std.mem.zeroes(u16),
    no_local_flag: bool = std.mem.zeroes(bool),
    retain_as_published_flag: bool = std.mem.zeroes(bool),
    retain_handle: u8 = std.mem.zeroes(u8),
    is_share_subscribe: bool = std.mem.zeroes(bool),
    share_name: [*:0]const u8 = "",
    user_property: mqtt5_user_property_handle_t = std.mem.zeroes(mqtt5_user_property_handle_t),
};
pub const esp_mqtt5_unsubscribe_property_config_t = extern struct {
    is_share_subscribe: bool = std.mem.zeroes(bool),
    share_name: [*:0]const u8 = "",
    user_property: mqtt5_user_property_handle_t = std.mem.zeroes(mqtt5_user_property_handle_t),
};
pub const esp_mqtt5_disconnect_property_config_t = extern struct {
    session_expiry_interval: u32 = std.mem.zeroes(u32),
    disconnect_reason: u8 = std.mem.zeroes(u8),
    user_property: mqtt5_user_property_handle_t = std.mem.zeroes(mqtt5_user_property_handle_t),
};
pub const esp_mqtt5_event_property_t = extern struct {
    payload_format_indicator: bool = std.mem.zeroes(bool),
    response_topic: [*:0]u8 = std.mem.zeroes([*:0]u8),
    response_topic_len: c_int = std.mem.zeroes(c_int),
    correlation_data: [*:0]u8 = std.mem.zeroes([*:0]u8),
    correlation_data_len: u16 = std.mem.zeroes(u16),
    content_type: [*:0]u8 = std.mem.zeroes([*:0]u8),
    content_type_len: c_int = std.mem.zeroes(c_int),
    subscribe_id: u16 = std.mem.zeroes(u16),
    user_property: mqtt5_user_property_handle_t = std.mem.zeroes(mqtt5_user_property_handle_t),
};
pub const esp_mqtt5_user_property_item_t = extern struct {
    key: [*:0]const u8 = "",
    value: [*:0]const u8 = "",
};
pub extern fn esp_mqtt5_client_set_connect_property(client: esp_mqtt5_client_handle_t, connect_property: [*c]const esp_mqtt5_connection_property_config_t) sys.esp_err_t;
pub extern fn esp_mqtt5_client_set_publish_property(client: esp_mqtt5_client_handle_t, property: [*c]const esp_mqtt5_publish_property_config_t) sys.esp_err_t;
pub extern fn esp_mqtt5_client_set_subscribe_property(client: esp_mqtt5_client_handle_t, property: [*c]const esp_mqtt5_subscribe_property_config_t) sys.esp_err_t;
pub extern fn esp_mqtt5_client_set_unsubscribe_property(client: esp_mqtt5_client_handle_t, property: [*c]const esp_mqtt5_unsubscribe_property_config_t) sys.esp_err_t;
pub extern fn esp_mqtt5_client_set_disconnect_property(client: esp_mqtt5_client_handle_t, property: [*c]const esp_mqtt5_disconnect_property_config_t) sys.esp_err_t;
pub extern fn esp_mqtt5_client_set_user_property(user_property: [*c]mqtt5_user_property_handle_t, item: [*c]esp_mqtt5_user_property_item_t, item_num: u8) sys.esp_err_t;
pub extern fn esp_mqtt5_client_get_user_property(user_property: mqtt5_user_property_handle_t, item: [*c]esp_mqtt5_user_property_item_t, item_num: [*:0]u8) sys.esp_err_t;
pub extern fn esp_mqtt5_client_get_user_property_count(user_property: mqtt5_user_property_handle_t) u8;
pub extern fn esp_mqtt5_client_delete_user_property(user_property: mqtt5_user_property_handle_t) void;
