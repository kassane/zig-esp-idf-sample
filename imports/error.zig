const sys = @import("sys");
const std = @import("std");

// Zig error
const esp_error = error{
    Fail,
    ErrorNoMem,
    ErrorInvalidArg,
    ErrorInvalidState,
    ErrorInvalidSize,
    ErrorNotFound,
    ErrorNotSupported,
    ErrorTimeout,
    ErrorInvalidResponse,
    ErrorInvalidCRC,
    ErrorInvalidVersion,
    ErrorInvalidMAC,
    ErrorNotFinished,
    ErrorNotAllowed,
    ErrorWiFiBase,
    ErrorMeshBase,
    ErrorFlashBase,
    ErrorHWCryptoBase,
    ErrorMemProtectBase,
};

// C to Zig error
pub fn espError(err: sys.esp_err_t) esp_error!sys.esp_err_t {
    return switch (@as(sys.esp_err_t, err)) {
        @as(sys.esp_err_t, sys.ESP_FAIL) => esp_error.Fail,
        @as(sys.esp_err_t, sys.ESP_ERR_NO_MEM) => esp_error.ErrorNoMem,
        @as(sys.esp_err_t, sys.ESP_ERR_INVALID_ARG) => esp_error.ErrorInvalidArg,
        @as(sys.esp_err_t, sys.ESP_ERR_INVALID_STATE) => esp_error.ErrorInvalidState,
        @as(sys.esp_err_t, sys.ESP_ERR_INVALID_SIZE) => esp_error.ErrorInvalidSize,
        @as(sys.esp_err_t, sys.ESP_ERR_NOT_FOUND) => esp_error.ErrorNotFound,
        @as(sys.esp_err_t, sys.ESP_ERR_NOT_SUPPORTED) => esp_error.ErrorNotSupported,
        @as(sys.esp_err_t, sys.ESP_ERR_TIMEOUT) => esp_error.ErrorTimeout,
        @as(sys.esp_err_t, sys.ESP_ERR_INVALID_RESPONSE) => esp_error.ErrorInvalidResponse,
        @as(sys.esp_err_t, sys.ESP_ERR_INVALID_CRC) => esp_error.ErrorInvalidCRC,
        @as(sys.esp_err_t, sys.ESP_ERR_INVALID_VERSION) => esp_error.ErrorInvalidVersion,
        @as(sys.esp_err_t, sys.ESP_ERR_INVALID_MAC) => esp_error.ErrorInvalidMAC,
        @as(sys.esp_err_t, sys.ESP_ERR_NOT_FINISHED) => esp_error.ErrorNotFinished,
        @as(sys.esp_err_t, sys.ESP_ERR_NOT_ALLOWED) => esp_error.ErrorNotAllowed,
        @as(sys.esp_err_t, sys.ESP_ERR_WIFI_BASE) => esp_error.ErrorWiFiBase,
        @as(sys.esp_err_t, sys.ESP_ERR_MESH_BASE) => esp_error.ErrorMeshBase,
        @as(sys.esp_err_t, sys.ESP_ERR_FLASH_BASE) => esp_error.ErrorFlashBase,
        @as(sys.esp_err_t, sys.ESP_ERR_HW_CRYPTO_BASE) => esp_error.ErrorHWCryptoBase,
        @as(sys.esp_err_t, sys.ESP_ERR_MEMPROT_BASE) => esp_error.ErrorMemProtectBase,
        else => err, // Return the original `sys.esp_err_t` if it's not mapped
    };
}

pub fn espCheckError(errc: sys.esp_err_t) esp_error!void {
    if (try espError(errc) == @as(sys.esp_err_t, sys.ESP_OK))
        return;
}
