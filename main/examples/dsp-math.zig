const std = @import("std");
const idf = @import("esp_idf");
const dsp = idf.dsp;
const sys = idf.sys;
const log = std.log.scoped(.dsp_basic);

comptime {
    @export(&main, .{ .name = "app_main" });
}

// Configuration
const N_SAMPLES: u32 = 1024;
const TONE_AMPLITUDE: f32 = 1.0;
const TONE_FREQUENCY: f32 = 0.2; // Normalized frequency (0.0 to 0.5)

// Process and display FFT results
fn processAndShow(allocator: std.mem.Allocator, data: []f32, length: u32) !void {
    // Perform FFT
    const fft_table = try allocator.alloc(f32, length);
    defer allocator.free(fft_table);

    try dsp.FFT.initRadix2F32(fft_table, length);
    defer dsp.FFT.deinitRadix2F32();

    try dsp.FFT.fft2rF32(data, length, fft_table);

    // Bit reverse
    try dsp.FFT.bitReverseF32(data, length);

    // Convert complex to real (cplx2reC)
    try idf.err.espCheckError(sys.dsps_cplx2reC_fc32_ansi(
        data.ptr,
        @intCast(length),
    ));

    // Calculate power spectrum in dB: 10 * log10((re^2 + im^2) / N)
    const N_f32: f32 = @floatFromInt(N_SAMPLES);
    var i: u32 = 0;
    while (i < length / 2) : (i += 1) {
        const idx = i * 2;
        const re = data[idx];
        const im = data[idx + 1];
        const power = (re * re + im * im) / N_f32;
        data[i] = 10.0 * @log10(power);
    }

    // Display spectrum: 64 chars wide, 10 lines tall, -120 to 40 dB range
    log.info("Power Spectrum (dB):", .{});
    dsp.Utils.viewSignalF32(data[0..(length / 2)], 64, 10, -120.0, 40.0);
}

fn main() callconv(.c) void {
    log.info("*** ESP-DSP Basic Math Example (Zig) ***", .{});

    var heap: idf.heap.vPortAllocator = .init();
    const allocator = heap.allocator();

    log.info("Available heap: {} bytes", .{heap.freeSize()});

    // Allocate arrays
    const x1 = allocator.alloc(f32, N_SAMPLES) catch {
        log.err("Failed to allocate x1 array", .{});
        return;
    };
    defer allocator.free(x1);

    const wind = allocator.alloc(f32, N_SAMPLES) catch {
        log.err("Failed to allocate window array", .{});
        return;
    };
    defer allocator.free(wind);

    const y_cf = allocator.alloc(f32, N_SAMPLES * 2) catch {
        log.err("Failed to allocate complex array", .{});
        return;
    };
    defer allocator.free(y_cf);

    // Generate Hann window
    dsp.Window.hann(wind);
    log.info("Hann window generated", .{});

    // ═════════════════════════════════════════════════════════════════════════
    // Method 1: Multiply using standard loop
    // ═════════════════════════════════════════════════════════════════════════

    log.info("\n*** Method 1: Multiply tone with Hann window using loop ***", .{});

    // Generate tone signal
    dsp.Signal.generateToneF32(x1, TONE_AMPLITUDE, TONE_FREQUENCY, 0.0) catch {
        log.err("Failed to generate tone", .{});
        return;
    };

    // Convert to complex and multiply with window using loop
    var i: u32 = 0;
    while (i < N_SAMPLES) : (i += 1) {
        y_cf[i * 2 + 0] = x1[i] * wind[i]; // Real part (windowed signal)
        y_cf[i * 2 + 1] = 0.0; // Imaginary part (zero)
    }

    // Process and display
    processAndShow(allocator, y_cf, N_SAMPLES) catch |err| {
        log.err("FFT processing failed: {s}", .{@errorName(err)});
        return;
    };

    // ═════════════════════════════════════════════════════════════════════════
    // Method 2: Multiply using DSP basic math functions
    // ═════════════════════════════════════════════════════════════════════════

    log.info("\n*** Method 2: Multiply tone with Hann window using DSP functions ***", .{});

    // Generate tone signal again
    dsp.Signal.generateToneF32(x1, TONE_AMPLITUDE, TONE_FREQUENCY, 0.0) catch {
        log.err("Failed to generate tone", .{});
        return;
    };

    // Method using DSP multiply functions
    // Step 1: Multiply input with window and store as real part (every 2nd element)
    idf.err.espCheckError(sys.dsps_mul_f32_ae32(
        x1.ptr, // input1
        wind.ptr, // input2 (window)
        y_cf.ptr, // output
        @intCast(N_SAMPLES), // length
        1, // step1
        1, // step2
        2, // step_out (store every 2nd element for complex)
    )) catch {
        log.err("Failed to multiply arrays", .{});
        return;
    };

    // Step 2: Clear imaginary part (multiply by 0 with step=2)
    // Start from index 1 (imaginary parts)
    idf.err.espCheckError(sys.dsps_mulc_f32_ae32(
        &y_cf[1], // input (starting at imaginary part)
        &y_cf[1], // output (same)
        @intCast(N_SAMPLES), // length
        0.0, // constant (multiply by 0 to clear)
        2, // step_in (every 2nd element)
        2, // step_out (every 2nd element)
    )) catch {
        log.err("Failed to clear imaginary part", .{});
        return;
    };

    // Process and display
    processAndShow(allocator, y_cf, N_SAMPLES) catch |err| {
        log.err("FFT processing failed: {s}", .{@errorName(err)});
        return;
    };

    log.info("\n*** Example Complete ***", .{});
    log.info("Free heap: {} bytes", .{heap.freeSize()});

    // Keep running
    while (true) {
        idf.rtos.vTaskDelay(10000 / idf.rtos.portTICK_PERIOD_MS);
    }
}

pub const panic = idf.esp_panic.panic;
pub const std_options: std.Options = .{
    .log_level = .info,
    .logFn = idf.log.espLogFn,
};
