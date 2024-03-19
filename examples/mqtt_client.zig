const std = @import("std");
const esp_idf = @import("esp_idf");

export fn esp_mqtt_event_handle_cb(event: esp_idf.esp_mqtt_event_handle_t) void {
    const client = event.*.client;
    var msg_id: c_int = 0;
    switch (event.*.event_id) {
        .MQTT_EVENT_CONNECTED => {
            log.info("MQTT_EVENT_CONNECTED", .{});
            msg_id = esp_idf.esp_mqtt_client_publish(client, "/topic/qos1", "data_3", 0, 1, 0);
            log.info("sent publish successful, msg_id={d}", .{msg_id});
            msg_id = esp_idf.esp_mqtt_client_subscribe_single(client, "/topic/qos0", 0);
            log.info("sent subscribe successful, msg_id={d}", .{msg_id});
            msg_id = esp_idf.esp_mqtt_client_subscribe_single(client, "/topic/qos1", 1);
            log.info("sent subscribe successful, msg_id={d}", .{msg_id});
            msg_id = esp_idf.esp_mqtt_client_unsubscribe(client, "/topic/qos0");
            log.info("sent subscribe successful, msg_id={d}", .{msg_id});
        },
        .MQTT_EVENT_DISCONNECTED => {
            log.info("MQTT_EVENT_DISCONNECTED", .{});
        },
        .MQTT_EVENT_SUBSCRIBED => {
            log.info("MQTT_EVENT_SUBSCRIBED, msg_id={d}", .{event.*.msg_id});
            msg_id = esp_idf.esp_mqtt_client_publish(client, "/topic/qos0", "data", 0, 0, 0);
            log.info("sent publish successful, msg_id={d}", .{msg_id});
        },
        .MQTT_EVENT_UNSUBSCRIBED => {
            log.info("MQTT_EVENT_UNSUBSCRIBED, msg_id={d}", .{event.*.msg_id});
        },
        .MQTT_EVENT_PUBLISHED => {
            log.info("MQTT_EVENT_PUBLISHED, msg_id={d}", .{event.*.msg_id});
        },
        .MQTT_EVENT_DATA => {
            log.info("MQTT_EVENT_DATA", .{});
            _ = std.c.printf("TOPIC=%.*s\r\n", event.*.topic_len, event.*.topic);
            _ = std.c.printf("DATA=%.*s\r\n", event.*.data_len, event.*.data);
        },
        .MQTT_EVENT_ERROR => {
            log.info("MQTT_EVENT_ERROR", .{});
            if (event.*.error_handle.*.error_type == .MQTT_ERROR_TYPE_TCP_TRANSPORT) {
                log.err("reported from esp-tls ({})", .{event.*.error_handle.*.esp_tls_last_esp_err});
                log.err("reported from tls stack ({})", .{event.*.error_handle.*.esp_tls_stack_err});
                log.err("captured as transport's socket errno ({})", .{event.*.error_handle.*.esp_transport_sock_errno});
                log.info("Last errno ({})", .{event.*.error_handle.*.esp_transport_sock_errno});
            }
        },
        else => log.info("Other event id:{}", .{event.*.event_id}),
    }
}
export fn mqtt_event_handler(handler_args: ?*anyopaque, base: esp_idf.esp_event_base_t, event_id: i32, event_data: ?*anyopaque) void {
    _ = handler_args; // autofix
    log.info("MQTT base: {s} event: {d}", .{ base, event_id });
    esp_mqtt_event_handle_cb(@ptrCast(@alignCast(event_data)));
}

export fn app_main() callconv(.C) void {
    var mqtt_init: esp_idf.esp_mqtt_client_config_t = .{
        .broker = .{
            .address = .{
                .uri = "mqtt://mqtt.eclipse.org",
            },
        },
    };
    const client = esp_idf.esp_mqtt_client_init(&mqtt_init);
    esp_idf.espCheckError(esp_idf.esp_mqtt_client_register_event(
        client,
        .MQTT_EVENT_ANY,
        &mqtt_event_handler,
        null,
    )) catch |err|
        @panic(@errorName(err));
    esp_idf.espCheckError(esp_idf.esp_mqtt_client_start(client)) catch |err|
        @panic(@errorName(err));
}

// override the std panic function with esp_idf.panic
pub usingnamespace if (!@hasDecl(@This(), "panic"))
    struct {
        pub const panic = esp_idf.panic;
    }
else
    struct {};

const log = std.log.scoped(.esp_idf);
pub const std_options = .{
    .log_level = switch (@import("builtin").mode) {
        .Debug => .debug,
        else => .info,
    },
    // Define logFn to override the std implementation
    .logFn = esp_idf.espLogFn,
};

const tag = "mqtt-client";
