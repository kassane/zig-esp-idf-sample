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
    return switch (err) {
        .ESP_FAIL => esp_error.Fail,
        .ESP_ERR_NO_MEM => esp_error.ErrorNoMem,
        .ESP_ERR_INVALID_ARG => esp_error.ErrorInvalidArg,
        .ESP_ERR_INVALID_STATE => esp_error.ErrorInvalidState,
        .ESP_ERR_INVALID_SIZE => esp_error.ErrorInvalidSize,
        .ESP_ERR_NOT_FOUND => esp_error.ErrorNotFound,
        .ESP_ERR_NOT_SUPPORTED => esp_error.ErrorNotSupported,
        .ESP_ERR_TIMEOUT => esp_error.ErrorTimeout,
        .ESP_ERR_INVALID_RESPONSE => esp_error.ErrorInvalidResponse,
        .ESP_ERR_INVALID_CRC => esp_error.ErrorInvalidCRC,
        .ESP_ERR_INVALID_VERSION => esp_error.ErrorInvalidVersion,
        .ESP_ERR_INVALID_MAC => esp_error.ErrorInvalidMAC,
        .ESP_ERR_NOT_FINISHED => esp_error.ErrorNotFinished,
        .ESP_ERR_NOT_ALLOWED => esp_error.ErrorNotAllowed,
        .ESP_ERR_WIFI_BASE => esp_error.ErrorWiFiBase,
        .ESP_ERR_MESH_BASE => esp_error.ErrorMeshBase,
        .ESP_ERR_FLASH_BASE => esp_error.ErrorFlashBase,
        .ESP_ERR_HW_CRYPTO_BASE => esp_error.ErrorHWCryptoBase,
        .ESP_ERR_MEMPROT_BASE => esp_error.ErrorMemProtectBase,
        else => .ESP_OK,
    };
}

pub fn espCheckError(errc: sys.esp_err_t) esp_error!void {
    if (try espError(errc) == sys.esp_err_t.ESP_OK)
        return;
}
