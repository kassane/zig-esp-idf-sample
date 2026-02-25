const sys = @import("sys");
const errors = @import("error");

// ---------------------------------------------------------------------------
// http_parser (third-party parser bundled with ESP-IDF)
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// HTTP server (httpd)
// ---------------------------------------------------------------------------

pub const Server = struct {
    /// Start the HTTP server. Returns a handle on success.
    pub fn start(config: *const sys.httpd_config_t) !sys.httpd_handle_t {
        var handle: sys.httpd_handle_t = null;
        try errors.espCheckError(sys.httpd_start(&handle, config));
        return handle;
    }

    /// Stop and clean up the HTTP server.
    pub fn stop(handle: sys.httpd_handle_t) !void {
        return errors.espCheckError(sys.httpd_stop(handle));
    }

    /// Register a URI handler.
    pub fn registerUri(handle: sys.httpd_handle_t, uri_handler: *const sys.httpd_uri_t) !void {
        return errors.espCheckError(sys.httpd_register_uri_handler(handle, uri_handler));
    }

    /// Unregister a URI handler by URI string and method.
    pub fn unregisterUri(handle: sys.httpd_handle_t, uri: [*:0]const u8, method: sys.httpd_method_t) !void {
        return errors.espCheckError(sys.httpd_unregister_uri_handler(handle, uri, method));
    }

    /// Unregister all URI handlers for a given URI string.
    pub fn unregisterAllUris(handle: sys.httpd_handle_t, uri: [*:0]const u8) !void {
        return errors.espCheckError(sys.httpd_unregister_uri(handle, uri));
    }

    pub const Session = struct {
        pub fn setReceiveOverride(hd: sys.httpd_handle_t, sockfd: c_int, recv_func: sys.httpd_recv_func_t) !void {
            return errors.espCheckError(sys.httpd_sess_set_recv_override(hd, sockfd, recv_func));
        }
        pub fn setSendOverride(hd: sys.httpd_handle_t, sockfd: c_int, send_func: sys.httpd_send_func_t) !void {
            return errors.espCheckError(sys.httpd_sess_set_send_override(hd, sockfd, send_func));
        }
        pub fn setPendingOverride(hd: sys.httpd_handle_t, sockfd: c_int, pending_func: sys.httpd_pending_func_t) !void {
            return errors.espCheckError(sys.httpd_sess_set_pending_override(hd, sockfd, pending_func));
        }
        pub fn triggerClose(handle: sys.httpd_handle_t, sockfd: c_int) !void {
            return errors.espCheckError(sys.httpd_sess_trigger_close(handle, sockfd));
        }
        pub fn updateLRUCounter(handle: sys.httpd_handle_t, sockfd: c_int) !void {
            return errors.espCheckError(sys.httpd_sess_update_lru_counter(handle, sockfd));
        }
        pub const getContext = sys.httpd_sess_get_ctx;
        pub const setContext = sys.httpd_sess_set_ctx;
        pub const getTransportContext = sys.httpd_sess_get_transport_ctx;
        pub const setTransportContext = sys.httpd_sess_set_transport_ctx;
    };

    pub const Request = struct {
        pub fn asyncHandlerBegin(r: [*c]sys.httpd_req_t, out: [*c][*c]sys.httpd_req_t) !void {
            return errors.espCheckError(sys.httpd_req_async_handler_begin(r, out));
        }
        pub fn asyncHandlerComplete(r: [*c]sys.httpd_req_t) !void {
            return errors.espCheckError(sys.httpd_req_async_handler_complete(r));
        }
        pub const toSockfd = sys.httpd_req_to_sockfd;
        pub const receiver = sys.httpd_req_recv;
        pub const getHDRValueLen = sys.httpd_req_get_hdr_value_len;
        pub fn getHDRValueStr(r: [*c]sys.httpd_req_t, field: [*:0]const u8, val: [*:0]u8, val_size: usize) !void {
            return errors.espCheckError(sys.httpd_req_get_hdr_value_str(r, field, val, val_size));
        }
        pub const getUrlQueryLen = sys.httpd_req_get_url_query_len;
        pub fn getUrlQueryStr(r: [*c]sys.httpd_req_t, buf: [*:0]u8, buf_len: usize) !void {
            return errors.espCheckError(sys.httpd_req_get_url_query_str(r, buf, buf_len));
        }
        pub fn getCookieValue(req: [*c]sys.httpd_req_t, cookie_name: [*:0]const u8, val: [*:0]u8, val_size: [*c]usize) !void {
            return errors.espCheckError(sys.httpd_req_get_cookie_val(req, cookie_name, val, val_size));
        }
    };

    pub fn queryKeyValue(qry: [*:0]const u8, key: [*:0]const u8, val: [*:0]u8, val_size: usize) !void {
        return errors.espCheckError(sys.httpd_query_key_value(qry, key, val, val_size));
    }

    pub const uri_MatchWildcard = sys.httpd_uri_match_wildcard;

    pub const Response = struct {
        /// Send a complete response with a byte-slice body.
        pub fn send(r: [*c]sys.httpd_req_t, buf: []const u8) !void {
            return errors.espCheckError(sys.httpd_resp_send(r, buf.ptr, @intCast(buf.len)));
        }
        /// Send a response chunk with a byte-slice body.
        pub fn sendChunk(r: [*c]sys.httpd_req_t, buf: []const u8) !void {
            return errors.espCheckError(sys.httpd_resp_send_chunk(r, buf.ptr, @intCast(buf.len)));
        }
        /// Send a null-terminated string as the complete response.
        /// Passes -1 (HTTPD_RESP_USE_STRLEN) so ESP-IDF calls strlen.
        pub fn sendStr(r: [*c]sys.httpd_req_t, str: [*:0]const u8) !void {
            return errors.espCheckError(sys.httpd_resp_send(r, str, -1));
        }
        /// Send a null-terminated string as a response chunk.
        pub fn sendStrChunk(r: [*c]sys.httpd_req_t, str: [*:0]const u8) !void {
            return errors.espCheckError(sys.httpd_resp_send_chunk(r, str, -1));
        }
        pub fn setStatus(r: [*c]sys.httpd_req_t, status: [*:0]const u8) !void {
            return errors.espCheckError(sys.httpd_resp_set_status(r, status));
        }
        pub fn setType(r: [*c]sys.httpd_req_t, @"type": [*:0]const u8) !void {
            return errors.espCheckError(sys.httpd_resp_set_type(r, @"type"));
        }
        pub fn setHDR(r: [*c]sys.httpd_req_t, field: [*:0]const u8, value: [*:0]const u8) !void {
            return errors.espCheckError(sys.httpd_resp_set_hdr(r, field, value));
        }
        pub fn sendError(req: [*c]sys.httpd_req_t, @"error": sys.httpd_err_code_t, msg: [*:0]const u8) !void {
            return errors.espCheckError(sys.httpd_resp_send_err(req, @"error", msg));
        }
        pub fn send404(r: [*c]sys.httpd_req_t) !void {
            return errors.espCheckError(sys.httpd_resp_send_err(r, .HTTPD_404_NOT_FOUND, null));
        }
        pub fn send408(r: [*c]sys.httpd_req_t) !void {
            return errors.espCheckError(sys.httpd_resp_send_err(r, .HTTPD_408_REQ_TIMEOUT, null));
        }
        pub fn send500(r: [*c]sys.httpd_req_t) !void {
            return errors.espCheckError(sys.httpd_resp_send_err(r, .HTTPD_500_INTERNAL_SERVER_ERROR, null));
        }
    };

    pub const rawSend = sys.httpd_send;

    pub const Socket = struct {
        pub const send = sys.httpd_socket_send;
        pub const receive = sys.httpd_socket_recv;
    };

    pub const getGlobalUserContext = sys.httpd_get_global_user_ctx;
    pub const getGlobalTransportContext = sys.httpd_get_global_transport_ctx;
    pub fn getClientList(handle: sys.httpd_handle_t, fds: [*c]usize, client_fds: [*c]c_int) !void {
        return errors.espCheckError(sys.httpd_get_client_list(handle, fds, client_fds));
    }
    pub const httpd_work_fn_t = sys.httpd_work_fn_t;
    pub fn queueWork(handle: sys.httpd_handle_t, work: httpd_work_fn_t, arg: ?*anyopaque) !void {
        return errors.espCheckError(sys.httpd_queue_work(handle, work, arg));
    }
};

// ---------------------------------------------------------------------------
// HTTP client (esp_http_client)
// ---------------------------------------------------------------------------

pub const Client = struct {
    handle: sys.esp_http_client_handle_t = null,

    /// Initialise the HTTP client from a config struct. Call `deinit()` when done.
    pub fn init(config: *const sys.esp_http_client_config_t) Client {
        return .{ .handle = sys.esp_http_client_init(config) };
    }

    /// Clean up the client handle. Must be called after use.
    pub fn deinit(self: Client) !void {
        return errors.espCheckError(sys.esp_http_client_cleanup(self.handle));
    }

    /// Perform a complete blocking request/response cycle.
    pub fn perform(self: Client) !void {
        return errors.espCheckError(sys.esp_http_client_perform(self.handle));
    }

    /// Open the connection (for streaming writes).
    /// `write_len` is Content-Length; pass 0 for requests without a body.
    pub fn open(self: Client, write_len: c_int) !void {
        return errors.espCheckError(sys.esp_http_client_open(self.handle, write_len));
    }

    /// Close the connection (without cleaning up the handle).
    pub fn close(self: Client) !void {
        return errors.espCheckError(sys.esp_http_client_close(self.handle));
    }

    /// Write request body data (call after `open()`).
    pub fn write(self: Client, data: []const u8) !c_int {
        const n = sys.esp_http_client_write(self.handle, data.ptr, @intCast(data.len));
        if (n < 0) return error.HttpWriteFailed;
        return n;
    }

    /// Fetch (read) response headers after `open()`.
    /// Returns Content-Length, or negative on error / chunked encoding.
    pub fn fetchHeaders(self: Client) i64 {
        return sys.esp_http_client_fetch_headers(self.handle);
    }

    /// Read response body into `buf`. Returns number of bytes read (0 = done).
    pub fn read(self: Client, buf: []u8) !c_int {
        const n = sys.esp_http_client_read(self.handle, buf.ptr, @intCast(buf.len));
        if (n < 0) return error.HttpReadFailed;
        return n;
    }

    /// Read the entire response into `buf` (convenience wrapper).
    pub fn readResponse(self: Client, buf: []u8) !c_int {
        const n = sys.esp_http_client_read_response(self.handle, buf.ptr, @intCast(buf.len));
        if (n < 0) return error.HttpReadFailed;
        return n;
    }

    /// HTTP status code of the last response.
    pub fn getStatusCode(self: Client) c_int {
        return sys.esp_http_client_get_status_code(self.handle);
    }

    /// Content-Length of the last response (-1 if unknown / chunked).
    pub fn getContentLength(self: Client) i64 {
        return sys.esp_http_client_get_content_length(self.handle);
    }

    /// Cancel the current in-progress request.
    pub fn cancelRequest(self: Client) !void {
        return errors.espCheckError(sys.esp_http_client_cancel_request(self.handle));
    }

    /// Setters — configure the client before calling `perform()` or `open()`.
    pub const Set = struct {
        pub fn url(client: sys.esp_http_client_handle_t, _url: [*:0]const u8) !void {
            return errors.espCheckError(sys.esp_http_client_set_url(client, _url));
        }
        pub fn postField(client: sys.esp_http_client_handle_t, data: []const u8) !void {
            return errors.espCheckError(sys.esp_http_client_set_post_field(client, data.ptr, @intCast(data.len)));
        }
        pub fn header(client: sys.esp_http_client_handle_t, field: [*:0]const u8, value: [*:0]const u8) !void {
            return errors.espCheckError(sys.esp_http_client_set_header(client, field, value));
        }
        pub fn username(client: sys.esp_http_client_handle_t, _username: [*:0]const u8) !void {
            return errors.espCheckError(sys.esp_http_client_set_username(client, _username));
        }
        pub fn password(client: sys.esp_http_client_handle_t, _password: [*:0]const u8) !void {
            return errors.espCheckError(sys.esp_http_client_set_password(client, _password));
        }
        pub fn method(client: sys.esp_http_client_handle_t, _method: sys.esp_http_client_method_t) !void {
            return errors.espCheckError(sys.esp_http_client_set_method(client, _method));
        }
        pub fn timeout(client: sys.esp_http_client_handle_t, timeout_ms: u32) !void {
            return errors.espCheckError(sys.esp_http_client_set_timeout_ms(client, timeout_ms));
        }
        pub fn userData(client: sys.esp_http_client_handle_t, user_data: ?*anyopaque) !void {
            return errors.espCheckError(sys.esp_http_client_set_user_data(client, user_data));
        }
        pub fn authData(client: sys.esp_http_client_handle_t, auth_data: []const u8) !void {
            return errors.espCheckError(sys.esp_http_client_set_auth_data(client, auth_data.ptr, @intCast(auth_data.len)));
        }
        pub fn authType(client: sys.esp_http_client_handle_t, auth_type: sys.esp_http_client_auth_type_t) !void {
            return errors.espCheckError(sys.esp_http_client_set_authtype(client, auth_type));
        }
        pub fn redirection(client: sys.esp_http_client_handle_t) !void {
            return errors.espCheckError(sys.esp_http_client_set_redirection(client));
        }
    };

    /// Getters — retrieve configuration or response state.
    pub const Get = struct {
        /// Copy the current URL into a buffer.
        pub fn url(client: sys.esp_http_client_handle_t, buf: []u8) !void {
            return errors.espCheckError(sys.esp_http_client_get_url(client, buf.ptr, @intCast(buf.len)));
        }
        /// Get a pointer to the POST field data (no copy).
        pub fn postField(client: sys.esp_http_client_handle_t, data: *[*c]const u8, len: *c_int) !void {
            return errors.espCheckError(sys.esp_http_client_get_post_field(client, data, len));
        }
        /// Get the value of a request header by key (returns pointer via `value`).
        pub fn header(client: sys.esp_http_client_handle_t, key: [*:0]const u8, value: *[*c]const u8) !void {
            return errors.espCheckError(sys.esp_http_client_get_header(client, key, value));
        }
        /// Get the configured username (returns pointer via `value`).
        pub fn username(client: sys.esp_http_client_handle_t, value: *[*c]const u8) !void {
            return errors.espCheckError(sys.esp_http_client_get_username(client, value));
        }
        /// Get the configured password (returns pointer via `value`).
        pub fn password(client: sys.esp_http_client_handle_t, value: *[*c]const u8) !void {
            return errors.espCheckError(sys.esp_http_client_get_password(client, value));
        }
        pub fn userData(client: sys.esp_http_client_handle_t, user_data: *?*anyopaque) !void {
            return errors.espCheckError(sys.esp_http_client_get_user_data(client, user_data));
        }
    };
};
