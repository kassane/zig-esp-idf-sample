// ESP-DSP (Digital Signal Processing) Library Wrapper
// requires: idf.py add-dependency espressif/esp-dsp
const sys = @import("sys");
const errors = @import("error");
const std = @import("std");

// ═══════════════════════════════════════════════════════════════════════════
// Complex number types
// ═══════════════════════════════════════════════════════════════════════════

/// Complex number with 16-bit integer components (short complex)
pub const Complex16 = extern struct {
    re: i16,
    im: i16,

    pub fn init(re: i16, im: i16) Complex16 {
        return .{ .re = re, .im = im };
    }

    pub fn fromUnion(u: sys.sc16_t) Complex16 {
        return .{ .re = u.unnamed_0.re, .im = u.unnamed_0.im };
    }

    pub fn toUnion(self: Complex16) sys.sc16_t {
        return .{ .unnamed_0 = .{ .re = self.re, .im = self.im } };
    }
};

/// Complex number with 32-bit float components (float complex)
pub const Complex32 = extern struct {
    re: f32,
    im: f32,

    pub fn init(re: f32, im: f32) Complex32 {
        return .{ .re = re, .im = im };
    }

    pub fn fromUnion(u: sys.fc32_t) Complex32 {
        return .{ .re = u.unnamed_0.re, .im = u.unnamed_0.im };
    }

    pub fn toUnion(self: Complex32) sys.fc32_t {
        return .{ .unnamed_0 = .{ .re = self.re, .im = self.im } };
    }

    pub fn magnitude(self: Complex32) f32 {
        return @sqrt(self.re * self.re + self.im * self.im);
    }

    pub fn phase(self: Complex32) f32 {
        return std.math.atan2(self.im, self.re);
    }
};

// ═══════════════════════════════════════════════════════════════════════════
// Image/2D data structure
// ═══════════════════════════════════════════════════════════════════════════

pub const Image2D = extern struct {
    data: ?*anyopaque = null,
    step_x: c_int = 0,
    step_y: c_int = 0,
    stride_x: c_int = 0,
    stride_y: c_int = 0,

    pub fn init(data: *anyopaque, step_x: i32, step_y: i32, stride_x: i32, stride_y: i32) Image2D {
        return .{ .data = data, .step_x = step_x, .step_y = step_y, .stride_x = stride_x, .stride_y = stride_y };
    }
};

// ═══════════════════════════════════════════════════════════════════════════
// Filter structures
// ═══════════════════════════════════════════════════════════════════════════

/// FIR filter with float32 coefficients
pub const FirF32 = struct {
    inner: sys.fir_f32_t,

    pub fn init(coeffs: []f32, delay: []f32) !FirF32 {
        if (coeffs.len != delay.len) return error.LengthMismatch;

        var fir: sys.fir_f32_t = undefined;
        try errors.espCheckError(sys.dsps_fir_init_f32(&fir, coeffs.ptr, delay.ptr, @intCast(coeffs.len)));

        return .{ .inner = fir };
    }

    pub fn initDecimated(coeffs: []f32, delay: []f32, decimation: u32) !FirF32 {
        if (coeffs.len != delay.len) return error.LengthMismatch;

        var fir: sys.fir_f32_t = undefined;
        try errors.espCheckError(sys.dsps_fird_init_f32(&fir, coeffs.ptr, delay.ptr, @intCast(coeffs.len), @intCast(decimation)));

        return .{ .inner = fir };
    }

    pub fn process(self: *FirF32, input: []const f32, output: []f32) !void {
        if (input.len != output.len) return error.LengthMismatch;
        try errors.espCheckError(sys.dsps_fir_f32_ae32(&self.inner, input.ptr, output.ptr, @intCast(input.len)));
    }

    pub fn deinit(self: *FirF32) !void {
        try errors.espCheckError(sys.dsps_fir_f32_free(&self.inner));
    }
};

/// FIR filter with int16 coefficients
pub const FirS16 = struct {
    inner: sys.fir_s16_t,

    pub fn initDecimated(coeffs: []i16, delay: []i16, decimation: u16, start_pos: u16, shift: u16) !FirS16 {
        if (coeffs.len != delay.len) return error.LengthMismatch;

        var fir: sys.fir_s16_t = undefined;
        try errors.espCheckError(sys.dsps_fird_init_s16(&fir, coeffs.ptr, delay.ptr, @intCast(coeffs.len), @intCast(decimation), @intCast(start_pos), @intCast(shift)));

        return .{ .inner = fir };
    }

    pub fn process(self: *FirS16, input: []const i16, output: []i16) !u32 {
        if (input.len != output.len) return error.LengthMismatch;
        const result = sys.dsps_fird_s16_aes3(&self.inner, input.ptr, output.ptr, @intCast(input.len));
        return @intCast(result);
    }

    pub fn deinit(self: *FirS16) !void {
        try errors.espCheckError(sys.dsps_fird_s16_aexx_free(&self.inner));
    }
};

// ═══════════════════════════════════════════════════════════════════════════
// FFT operations
// ═══════════════════════════════════════════════════════════════════════════

pub const FFT = struct {
    /// Initialize FFT with radix-2 (power of 2 sizes)
    pub fn initRadix2F32(table_buffer: []f32, table_size: u32) !void {
        try errors.espCheckError(sys.dsps_fft2r_init_fc32(table_buffer.ptr, @intCast(table_size)));
    }

    pub fn deinitRadix2F32() void {
        sys.dsps_fft2r_deinit_fc32();
    }

    /// Perform radix-2 FFT on complex data (in-place)
    /// data must be [re0, im0, re1, im1, ...] format
    pub fn fft2rF32(data: []f32, fft_size: u32, w_table: []f32) !void {
        try errors.espCheckError(sys.dsps_fft2r_fc32_aes3_(data.ptr, @intCast(fft_size), w_table.ptr));
    }

    /// Bit-reverse reordering for FFT
    pub fn bitReverseF32(data: []f32, fft_size: u32) !void {
        try errors.espCheckError(sys.dsps_bit_rev_fc32_ansi(data.ptr, @intCast(fft_size)));
    }

    /// Initialize FFT with radix-4 (optimized for power of 4 sizes)
    pub fn initRadix4F32(table_buffer: []f32, max_fft_size: u32) !void {
        try errors.espCheckError(sys.dsps_fft4r_init_fc32(table_buffer.ptr, @intCast(max_fft_size)));
    }

    pub fn deinitRadix4F32() void {
        sys.dsps_fft4r_deinit_fc32();
    }

    /// Perform radix-4 FFT
    pub fn fft4rF32(data: []f32, fft_size: u32, w_table: []f32) !void {
        try errors.espCheckError(sys.dsps_fft4r_fc32_ae32_(data.ptr, @intCast(fft_size), w_table.ptr, @intCast(w_table.len)));
    }

    /// Convert complex FFT output to real signal
    pub fn complex2RealF32(data: []f32, fft_size: u32, w_table: []f32) !void {
        try errors.espCheckError(sys.dsps_cplx2real_fc32_ae32_(data.ptr, @intCast(fft_size), w_table.ptr, @intCast(w_table.len)));
    }
};

// ═══════════════════════════════════════════════════════════════════════════
// Basic math operations
// ═══════════════════════════════════════════════════════════════════════════

pub const Math = struct {
    /// Vector addition: output = input1 + input2
    pub fn addF32(input1: []const f32, input2: []const f32, output: []f32) !void {
        if (input1.len != input2.len or input1.len != output.len) {
            return error.LengthMismatch;
        }
        try errors.espCheckError(sys.dsps_add_f32_ae32(input1.ptr, input2.ptr, output.ptr, @intCast(input1.len), 1, 1, 1));
    }

    /// Vector addition (16-bit): output = input1 + input2
    pub fn addS16(input1: []const i16, input2: []const i16, output: []i16, shift: i32) !void {
        if (input1.len != input2.len or input1.len != output.len) {
            return error.LengthMismatch;
        }
        try errors.espCheckError(sys.dsps_add_s16_aes3(input1.ptr, input2.ptr, output.ptr, @intCast(input1.len), 1, 1, 1, shift));
    }

    /// Vector subtraction: output = input1 - input2
    pub fn subF32(input1: []const f32, input2: []const f32, output: []f32) !void {
        if (input1.len != input2.len or input1.len != output.len) {
            return error.LengthMismatch;
        }
        try errors.espCheckError(sys.dsps_sub_f32_ae32(input1.ptr, input2.ptr, output.ptr, @intCast(input1.len), 1, 1, 1));
    }

    /// Vector multiplication: output = input1 * input2
    pub fn mulF32(input1: []const f32, input2: []const f32, output: []f32) !void {
        if (input1.len != input2.len or input1.len != output.len) {
            return error.LengthMismatch;
        }
        try errors.espCheckError(sys.dsps_mul_f32_ae32(input1.ptr, input2.ptr, output.ptr, @intCast(input1.len), 1, 1, 1));
    }

    /// Scalar addition: output = input + C
    pub fn addConstF32(input: []const f32, output: []f32, constant: f32) !void {
        if (input.len != output.len) return error.LengthMismatch;
        try errors.espCheckError(sys.dsps_addc_f32_ae32(input.ptr, output.ptr, @intCast(input.len), constant, 1, 1));
    }

    /// Scalar multiplication: output = input * C
    pub fn mulConstF32(input: []const f32, output: []f32, constant: f32) !void {
        if (input.len != output.len) return error.LengthMismatch;
        try errors.espCheckError(sys.dsps_mulc_f32_ae32(input.ptr, output.ptr, @intCast(input.len), constant, 1, 1));
    }

    /// Element-wise square root
    pub fn sqrtF32(input: []const f32, output: []f32) !void {
        if (input.len != output.len) return error.LengthMismatch;
        try errors.espCheckError(sys.dsps_sqrt_f32_ansi(input.ptr, output.ptr, @intCast(input.len)));
    }

    /// Dot product: result = sum(src1[i] * src2[i])
    pub fn dotProductF32(src1: []const f32, src2: []const f32) !f32 {
        if (src1.len != src2.len) return error.LengthMismatch;
        var result: f32 = 0;
        try errors.espCheckError(sys.dsps_dotprod_f32_aes3(src1.ptr, src2.ptr, &result, @intCast(src1.len)));
        return result;
    }

    /// Dot product (16-bit)
    pub fn dotProductS16(src1: []const i16, src2: []const i16, shift: i8) !i16 {
        if (src1.len != src2.len) return error.LengthMismatch;
        var result: i16 = 0;
        try errors.espCheckError(sys.dsps_dotprod_s16_ae32(src1.ptr, src2.ptr, &result, @intCast(src1.len), shift));
        return result;
    }
};

// ═══════════════════════════════════════════════════════════════════════════
// Matrix operations
// ═══════════════════════════════════════════════════════════════════════════

pub const Matrix = struct {
    /// Matrix multiplication: C = A * B
    /// A: m x k, B: k x n, C: m x n
    pub fn multiplyF32(A: []const f32, B: []const f32, C: []f32, m: u32, n: u32, k: u32) !void {
        try errors.espCheckError(sys.dspm_mult_f32_aes3(A.ptr, B.ptr, C.ptr, @intCast(m), @intCast(n), @intCast(k)));
    }

    /// Matrix addition: output = input1 + input2
    pub fn addF32(input1: []const f32, input2: []const f32, output: []f32, rows: u32, cols: u32) !void {
        try errors.espCheckError(sys.dspm_add_f32_ae32(input1.ptr, input2.ptr, output.ptr, @intCast(rows), @intCast(cols), 0, 0, 0, 1, 1, 1));
    }

    /// Matrix subtraction: output = input1 - input2
    pub fn subF32(input1: []const f32, input2: []const f32, output: []f32, rows: u32, cols: u32) !void {
        try errors.espCheckError(sys.dspm_sub_f32_ae32(input1.ptr, input2.ptr, output.ptr, @intCast(rows), @intCast(cols), 0, 0, 0, 1, 1, 1));
    }

    /// Scalar matrix multiplication: output = input * C
    pub fn mulConstF32(input: []const f32, output: []f32, constant: f32, rows: u32, cols: u32) !void {
        try errors.espCheckError(sys.dspm_mulc_f32_ae32(input.ptr, output.ptr, constant, @intCast(rows), @intCast(cols), 0, 0, 1, 1));
    }

    /// Optimized 3x3 matrix multiplication
    pub fn multiply3x3F32(A: []const f32, B: []const f32, C: []f32) !void {
        if (A.len < 9 or B.len < 9 or C.len < 9) return error.InvalidSize;
        try errors.espCheckError(sys.dspm_mult_3x3x3_f32_ae32(A.ptr, B.ptr, C.ptr));
    }

    /// Optimized 4x4 matrix multiplication
    pub fn multiply4x4F32(A: []const f32, B: []const f32, C: []f32) !void {
        if (A.len < 16 or B.len < 16 or C.len < 16) return error.InvalidSize;
        try errors.espCheckError(sys.dspm_mult_4x4x4_f32_ae32(A.ptr, B.ptr, C.ptr));
    }
};

// ═══════════════════════════════════════════════════════════════════════════
// Window functions
// ═══════════════════════════════════════════════════════════════════════════

pub const Window = struct {
    pub fn hann(window: []f32) void {
        sys.dsps_wind_hann_f32(window.ptr, @intCast(window.len));
    }

    pub fn blackman(window: []f32) void {
        sys.dsps_wind_blackman_f32(window.ptr, @intCast(window.len));
    }

    pub fn blackmanHarris(window: []f32) void {
        sys.dsps_wind_blackman_harris_f32(window.ptr, @intCast(window.len));
    }

    pub fn blackmanNuttall(window: []f32) void {
        sys.dsps_wind_blackman_nuttall_f32(window.ptr, @intCast(window.len));
    }

    pub fn nuttall(window: []f32) void {
        sys.dsps_wind_nuttall_f32(window.ptr, @intCast(window.len));
    }

    pub fn flatTop(window: []f32) void {
        sys.dsps_wind_flat_top_f32(window.ptr, @intCast(window.len));
    }
};

// ═══════════════════════════════════════════════════════════════════════════
// Biquad IIR filter
// ═══════════════════════════════════════════════════════════════════════════

pub const BiquadFilterType = enum {
    lowpass,
    highpass,
    bandpass,
    bandpass_0db,
    notch,
    allpass_360,
    allpass_180,
    peaking_eq,
    low_shelf,
    high_shelf,
};

pub const BiquadFilter = struct {
    coeffs: [5]f32,
    state: [2]f32,

    pub fn init(filter_type: BiquadFilterType, freq: f32, q_factor: f32, gain: f32) !BiquadFilter {
        var coeffs: [5]f32 = undefined;

        const result = switch (filter_type) {
            .lowpass => sys.dsps_biquad_gen_lpf_f32(&coeffs, freq, q_factor),
            .highpass => sys.dsps_biquad_gen_hpf_f32(&coeffs, freq, q_factor),
            .bandpass => sys.dsps_biquad_gen_bpf_f32(&coeffs, freq, q_factor),
            .bandpass_0db => sys.dsps_biquad_gen_bpf0db_f32(&coeffs, freq, q_factor),
            .notch => sys.dsps_biquad_gen_notch_f32(&coeffs, freq, gain, q_factor),
            .allpass_360 => sys.dsps_biquad_gen_allpass360_f32(&coeffs, freq, q_factor),
            .allpass_180 => sys.dsps_biquad_gen_allpass180_f32(&coeffs, freq, q_factor),
            .peaking_eq => sys.dsps_biquad_gen_peakingEQ_f32(&coeffs, freq, q_factor),
            .low_shelf => sys.dsps_biquad_gen_lowShelf_f32(&coeffs, freq, gain, q_factor),
            .high_shelf => sys.dsps_biquad_gen_highShelf_f32(&coeffs, freq, gain, q_factor),
        };

        try errors.espCheckError(result);

        return .{ .coeffs = coeffs, .state = std.mem.zeroes([2]f32) };
    }

    pub fn process(self: *BiquadFilter, input: []const f32, output: []f32) !void {
        if (input.len != output.len) return error.LengthMismatch;
        try errors.espCheckError(sys.dsps_biquad_f32_aes3(input.ptr, output.ptr, @intCast(input.len), &self.coeffs, &self.state));
    }

    pub fn reset(self: *BiquadFilter) void {
        self.state = std.mem.zeroes([2]f32);
    }
};

// ═══════════════════════════════════════════════════════════════════════════
// Convolution and correlation
// ═══════════════════════════════════════════════════════════════════════════

pub const Signal = struct {
    /// Convolution: convout = Signal ⊛ Kernel
    pub fn convolveF32(signal: []const f32, kernel: []const f32, output: []f32) !void {
        try errors.espCheckError(sys.dsps_conv_f32_ae32(signal.ptr, @intCast(signal.len), kernel.ptr, @intCast(kernel.len), output.ptr));
    }

    /// Cross-correlation: dest = Signal ⋆ Pattern
    pub fn correlateF32(signal: []const f32, pattern: []const f32, output: []f32) !void {
        try errors.espCheckError(sys.dsps_corr_f32_ae32(signal.ptr, @intCast(signal.len), pattern.ptr, @intCast(pattern.len), output.ptr));
    }

    /// Generate tone: output = Ampl * sin(2π * freq * t + phase)
    pub fn generateToneF32(output: []f32, amplitude: f32, frequency: f32, phase: f32) !void {
        try errors.espCheckError(sys.dsps_tone_gen_f32(output.ptr, @intCast(output.len), amplitude, frequency, phase));
    }

    /// Calculate Signal-to-Noise Ratio
    pub fn snrF32(input: []const f32, use_dc: bool) f32 {
        return sys.dsps_snr_f32(input.ptr, @intCast(input.len), if (use_dc) 1 else 0);
    }

    /// Calculate Spurious-Free Dynamic Range
    pub fn sfdrF32(input: []const f32, use_dc: bool) f32 {
        return sys.dsps_sfdr_f32(input.ptr, @intCast(input.len), if (use_dc) 1 else 0);
    }
};

// ═══════════════════════════════════════════════════════════════════════════
// DCT (Discrete Cosine Transform)
// ═══════════════════════════════════════════════════════════════════════════

pub const DCT = struct {
    /// Forward DCT (in-place)
    pub fn forwardF32(data: []f32) !void {
        try errors.espCheckError(sys.dsps_dct_f32(data.ptr, @intCast(data.len)));
    }

    /// Inverse DCT (in-place)
    pub fn inverseF32(data: []f32) !void {
        try errors.espCheckError(sys.dsps_dct_inv_f32(data.ptr, @intCast(data.len)));
    }
};

// ═══════════════════════════════════════════════════════════════════════════
// Utility functions
// ═══════════════════════════════════════════════════════════════════════════

pub const Utils = struct {
    /// Check if a number is a power of two
    pub fn isPowerOfTwo(x: i32) bool {
        return sys.dsp_is_power_of_two(x);
    }

    /// Get the power of two value (e.g., 3 → 8, 4 → 16)
    pub fn powerOfTwo(x: i32) i32 {
        return sys.dsp_power_of_two(x);
    }

    /// Visualize signal data (for debugging)
    pub fn viewSignalF32(data: []const f32, width: u32, height: u32, min: f32, max: f32) void {
        sys.dsps_view(data.ptr, @intCast(data.len), @intCast(width), @intCast(height), min, max, '*');
    }

    /// Visualize spectrum data (for debugging)
    pub fn viewSpectrumF32(data: []const f32, min: f32, max: f32) void {
        sys.dsps_view_spectrum(data.ptr, @intCast(data.len), min, max);
    }
};
