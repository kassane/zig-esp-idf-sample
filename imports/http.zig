const sys = @import("sys");
const errors = @import("error");

pub const Parser = struct {
    pub const version = sys.http_parser_version;
    pub const init = sys.http_parser_init;
    pub const settingsInit = sys.http_parser_settings_init;
    pub const execute = sys.http_parser_execute;
    pub const urlInit = sys.http_parser_url_init;
    pub const parseUrl = sys.http_parser_parse_url;
    pub const pause = sys.http_parser_pause;
};
pub const shouldKeepAlive = sys.http_should_keep_alive;
pub const methodStr = sys.http_method_str;
pub const errnoName = sys.http_errno_name;
pub const errnoDescription = sys.http_errno_description;
pub const bodyIsFinal = sys.http_body_is_final;

pub const Server = struct {
    pub const Session = struct {
        pub fn setReceiveOverride(hd: sys.httpd_handle_t, sockfd: c_int, recv_func: sys.httpd_recv_func_t) !void {
            return try errors.espCheckError(sys.httpd_sess_set_recv_override(hd, sockfd, recv_func));
        }
        pub fn setSendOverride(hd: sys.httpd_handle_t, sockfd: c_int, send_func: sys.httpd_send_func_t) !void {
            return try errors.espCheckError(sys.httpd_sess_set_send_override(hd, sockfd, send_func));
        }
        pub fn setPendingOverride(hd: sys.httpd_handle_t, sockfd: c_int, pending_func: sys.httpd_pending_func_t) !void {
            return try errors.espCheckError(sys.httpd_sess_set_pending_override(hd, sockfd, pending_func));
        }
        pub fn triggerClose(handle: sys.httpd_handle_t, sockfd: c_int) !void {
            return try errors.espCheckError(sys.httpd_sess_trigger_close(handle, sockfd));
        }
        pub fn updateLRUCounter(handle: sys.httpd_handle_t, sockfd: c_int) !void {
            return try errors.espCheckError(sys.httpd_sess_update_lru_counter(handle, sockfd));
        }
        pub const getContext = sys.httpd_sess_get_ctx;
        pub const setContext = sys.httpd_sess_set_ctx;
        pub const getTransportContext = sys.httpd_sess_get_transport_ctx;
        pub const setTransportContext = sys.httpd_sess_set_transport_ctx;
    };
    pub const Request = struct {
        pub fn asyncHandlerBegin(r: [*c]sys.httpd_req_t, out: [*c][*c]sys.httpd_req_t) !void {
            return try errors.espCheckError(sys.httpd_req_async_handler_begin(r, out));
        }
        pub fn asyncHandlerComplete(r: [*c]sys.httpd_req_t) !void {
            return try errors.espCheckError(sys.httpd_req_async_handler_complete(r));
        }
        pub const toSockfd = sys.httpd_req_to_sockfd;
        pub const receiver = sys.httpd_req_recv;
        pub const getHDRValueLen = sys.httpd_req_get_hdr_value_len;
        pub fn getHDRValueStr(r: [*c]sys.httpd_req_t, field: [*:0]const u8, val: [*:0]u8, val_size: usize) !void {
            return try errors.espCheckError(sys.httpd_req_get_hdr_value_str(r, field, val, val_size));
        }
        pub const getUrlQueryLen = sys.httpd_req_get_url_query_len;
        pub fn getUrlQueryStr(r: [*c]sys.httpd_req_t, buf: [*:0]u8, buf_len: usize) !void {
            return try errors.espCheckError(sys.httpd_req_get_url_query_str(r, buf, buf_len));
        }
        pub fn getCookieValue(req: [*c]sys.httpd_req_t, cookie_name: [*:0]const u8, val: [*:0]u8, val_size: [*c]usize) !void {
            return try errors.espCheckError(sys.httpd_req_get_cookie_val(req, cookie_name, val, val_size));
        }
    };
    pub fn queryKeyValue(qry: [*:0]const u8, key: [*:0]const u8, val: [*:0]u8, val_size: usize) !void {
        return try errors.espCheckError(sys.httpd_query_key_value(qry, key, val, val_size));
    }
    pub const uri_MatchWildcard = sys.httpd_uri_match_wildcard;
    pub const Response = struct {
        pub fn send(r: [*c]sys.httpd_req_t, buf: [*:0]const u8, buf_len: isize) !void {
            return try errors.espCheckError(sys.httpd_resp_send(r, buf, buf_len));
        }
        pub fn sendChunk(r: [*c]sys.httpd_req_t, buf: [*:0]const u8, buf_len: isize) !void {
            return try errors.espCheckError(sys.httpd_resp_send_chunk(r, buf, buf_len));
        }
        pub fn sendStr(r: [*c]sys.httpd_req_t, str: [*:0]const u8) callconv(.C) !void {
            return try errors.espCheckError(sys.httpd_resp_send(r, str, str.len));
        }
        pub fn sendStrChunk(r: [*c]sys.httpd_req_t, str: [*:0]const u8) callconv(.C) !void {
            return try errors.espCheckError(sys.httpd_resp_send_chunk(r, str, str.len));
        }
        pub fn setStatus(r: [*c]sys.httpd_req_t, status: [*:0]const u8) !void {
            return try errors.espCheckError(sys.httpd_resp_set_status(r, status));
        }
        pub fn setType(r: [*c]sys.httpd_req_t, @"type": [*:0]const u8) !void {
            return try errors.espCheckError(sys.httpd_resp_set_type(r, @"type"));
        }
        pub fn setHDR(r: [*c]sys.httpd_req_t, field: [*:0]const u8, value: [*:0]const u8) !void {
            return try errors.espCheckError(sys.httpd_resp_set_hdr(r, field, value));
        }
        pub fn sendError(req: [*c]sys.httpd_req_t, @"error": sys.httpd_err_code_t, msg: [*:0]const u8) !void {
            return try errors.espCheckError(sys.httpd_resp_send_err(req, @"error", msg));
        }
        pub fn send404(r: [*c]sys.httpd_req_t) callconv(.C) !void {
            return try errors.espCheckError(sys.httpd_resp_send_err(r, .HTTPD_404_NOT_FOUND, null));
        }
        pub fn send408(r: [*c]sys.httpd_req_t) callconv(.C) !void {
            return try errors.espCheckError(sys.httpd_resp_send_err(r, .HTTPD_408_REQ_TIMEOUT, null));
        }
        pub fn send500(r: [*c]sys.httpd_req_t) callconv(.C) !void {
            return try errors.espCheckError(sys.httpd_resp_send_err(r, .HTTPD_500_INTERNAL_SERVER_ERROR, null));
        }
    };
    pub const send = sys.httpd_send;
    pub const Socket = struct {
        pub const send = sys.httpd_socket_send;
        pub const receive = sys.httpd_socket_recv;
    };
    pub const getGlobalUserContext = sys.httpd_get_global_user_ctx;
    pub const getGlobalTransportContext = sys.httpd_get_global_transport_ctx;
    pub fn getClientList(handle: sys.httpd_handle_t, fds: [*c]usize, client_fds: [*c]c_int) !void {
        return try errors.espCheckError(sys.httpd_get_client_list(handle, fds, client_fds));
    }
    pub const httpd_work_fn_t = sys.httpd_work_fn_t;
    pub fn queueWork(handle: sys.httpd_handle_t, work: httpd_work_fn_t, arg: ?*anyopaque) !void {
        return try errors.espCheckError(sys.httpd_queue_work(handle, work, arg));
    }
};

pub const Client = struct {
    c_config: sys.esp_http_client_config_t = null,

    pub fn init(config: [*c]const sys.esp_http_client_config_t) Client {
        return .{
            .c_config = sys.esp_http_client_init(config),
        };
    }
    pub const Get = struct {
        pub fn url(client: sys.esp_http_client_handle_t, _url: [*:0]const u8) !void {
            return try errors.espCheckError(sys.esp_http_client_get_url(client, _url));
        }
        pub fn postField(client: sys.esp_http_client_handle_t, data: [*:0]const u8) !void {
            return try errors.espCheckError(sys.esp_http_client_get_post_field(client, data, @import("std").mem.len(data)));
        }
        pub fn header(client: sys.esp_http_client_handle_t, field: [*:0]const u8, value: [*:0]const u8) !void {
            return try errors.espCheckError(sys.esp_http_client_get_header(client, field, value));
        }
        pub fn username(client: sys.esp_http_client_handle_t, _username: [*:0]const u8) !void {
            return try errors.espCheckError(sys.esp_http_client_get_username(client, _username));
        }
        pub fn password(client: sys.esp_http_client_handle_t, _password: [*:0]const u8) !void {
            return try errors.espCheckError(sys.esp_http_client_get_password(client, _password));
        }
        pub fn userData(client: sys.esp_http_client_handle_t, user_data: ?*anyopaque) !void {
            return try errors.espCheckError(sys.esp_http_client_get_user_data(client, user_data));
        }
    };
    pub const Set = struct {
        pub fn url(client: sys.esp_http_client_handle_t, _url: [*:0]const u8) !void {
            return try errors.espCheckError(sys.esp_http_client_set_url(client, _url));
        }
        pub fn postField(client: sys.esp_http_client_handle_t, data: [*:0]const u8) !void {
            return try errors.espCheckError(sys.esp_http_client_set_post_field(client, data, @import("std").mem.len(data)));
        }
        pub fn header(client: sys.esp_http_client_handle_t, field: [*:0]const u8, value: [*:0]const u8) !void {
            return try errors.espCheckError(sys.esp_http_client_set_header(client, field, value));
        }
        pub fn username(client: sys.esp_http_client_handle_t, _username: [*:0]const u8) !void {
            return try errors.espCheckError(sys.esp_http_client_set_username(client, _username));
        }
        pub fn password(client: sys.esp_http_client_handle_t, _password: [*:0]const u8) !void {
            return try errors.espCheckError(sys.esp_http_client_set_password(client, _password));
        }
        pub fn method(client: sys.esp_http_client_handle_t, _method: sys.esp_http_method_t) !void {
            return try errors.espCheckError(sys.esp_http_client_set_method(client, _method));
        }
        pub fn timeout(client: sys.esp_http_client_handle_t, timeout_ms: u32) !void {
            return try errors.espCheckError(sys.esp_http_client_set_timeout_ms(client, timeout_ms));
        }
        pub fn userData(client: sys.esp_http_client_handle_t, user_data: ?*anyopaque) !void {
            return try errors.espCheckError(sys.esp_http_client_set_user_data(client, user_data));
        }
        pub fn authData(client: sys.esp_http_client_handle_t, auth_data: [*:0]const u8) !void {
            return try errors.espCheckError(sys.esp_http_client_set_auth_data(client, auth_data, @import("std").mem.len(auth_data)));
        }
        pub fn authType(client: sys.esp_http_client_handle_t, auth_type: sys.esp_http_auth_type_t) !void {
            return try errors.espCheckError(sys.esp_http_client_set_authtype(client, auth_type));
        }
        pub fn redirection(client: sys.esp_http_client_handle_t) !void {
            return try errors.espCheckError(sys.esp_http_client_set_redirection(client));
        }
    };
    pub fn perform(client: sys.esp_http_client_handle_t) !void {
        return try errors.espCheckError(sys.esp_http_client_perform(client));
    }
    pub const request = struct {
        pub fn cancel(client: sys.esp_http_client_handle_t) !void {
            return try errors.espCheckError(sys.esp_http_client_cancel_request(client));
        }
    };
};
