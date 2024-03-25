// need: idf.py add-dependency espressif/esp-dsp

const sys = @import("sys");
const std = @import("std");

const struct_unnamed_86 = extern struct {
    re: i16 = std.mem.zeroes(i16),
    im: i16 = std.mem.zeroes(i16),
};
pub const sc16_t = extern union {
    unnamed_0: struct_unnamed_86,
    data: u32,
};
const struct_unnamed_87 = extern struct {
    re: f32 = std.mem.zeroes(f32),
    im: f32 = std.mem.zeroes(f32),
};
pub const fc32_t = extern union {
    unnamed_0: struct_unnamed_87,
    data: u64,
};
pub const image2d_t = extern struct {
    data: ?*anyopaque = null,
    step_x: c_int = std.mem.zeroes(c_int),
    step_y: c_int = std.mem.zeroes(c_int),
    stride_x: c_int = std.mem.zeroes(c_int),
    stride_y: c_int = std.mem.zeroes(c_int),
};

pub extern fn dsp_is_power_of_two(x: c_int) bool;
pub extern fn dsp_power_of_two(x: c_int) c_int;
pub extern fn tie_log(n_regs: c_int, ...) sys.esp_err_t;
pub extern fn dsps_dotprod_s16_ansi(src1: [*c]const i16, src2: [*c]const i16, dest: [*c]i16, len: c_int, shift: i8) sys.esp_err_t;
pub extern fn dsps_dotprod_s16_ae32(src1: [*c]const i16, src2: [*c]const i16, dest: [*c]i16, len: c_int, shift: i8) sys.esp_err_t;
pub extern fn dsps_dotprod_f32_ansi(src1: [*c]const f32, src2: [*c]const f32, dest: [*c]f32, len: c_int) sys.esp_err_t;
pub extern fn dsps_dotprod_f32_ae32(src1: [*c]const f32, src2: [*c]const f32, dest: [*c]f32, len: c_int) sys.esp_err_t;
pub extern fn dsps_dotprod_f32_aes3(src1: [*c]const f32, src2: [*c]const f32, dest: [*c]f32, len: c_int) sys.esp_err_t;
pub extern fn dsps_dotprode_f32_ansi(src1: [*c]const f32, src2: [*c]const f32, dest: [*c]f32, len: c_int, step1: c_int, step2: c_int) sys.esp_err_t;
pub extern fn dsps_dotprode_f32_ae32(src1: [*c]const f32, src2: [*c]const f32, dest: [*c]f32, len: c_int, step1: c_int, step2: c_int) sys.esp_err_t;
pub extern fn dsps_add_f32_ansi(input1: [*c]const f32, input2: [*c]const f32, output: [*c]f32, len: c_int, step1: c_int, step2: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dsps_add_f32_ae32(input1: [*c]const f32, input2: [*c]const f32, output: [*c]f32, len: c_int, step1: c_int, step2: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dsps_add_s16_ansi(input1: [*c]const i16, input2: [*c]const i16, output: [*c]i16, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_add_s16_ae32(input1: [*c]const i16, input2: [*c]const i16, output: [*c]i16, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_add_s16_aes3(input1: [*c]const i16, input2: [*c]const i16, output: [*c]i16, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_add_s8_ansi(input1: [*c]const i8, input2: [*c]const i8, output: [*c]i8, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_add_s8_aes3(input1: [*c]const i8, input2: [*c]const i8, output: [*c]i8, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_sub_f32_ansi(input1: [*c]const f32, input2: [*c]const f32, output: [*c]f32, len: c_int, step1: c_int, step2: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dsps_sub_f32_ae32(input1: [*c]const f32, input2: [*c]const f32, output: [*c]f32, len: c_int, step1: c_int, step2: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dsps_sub_s16_ansi(input1: [*c]const i16, input2: [*c]const i16, output: [*c]i16, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_sub_s16_ae32(input1: [*c]const i16, input2: [*c]const i16, output: [*c]i16, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_sub_s16_aes3(input1: [*c]const i16, input2: [*c]const i16, output: [*c]i16, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_sub_s8_ansi(input1: [*c]const i8, input2: [*c]const i8, output: [*c]i8, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_sub_s8_aes3(input1: [*c]const i8, input2: [*c]const i8, output: [*c]i8, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_mul_f32_ansi(input1: [*c]const f32, input2: [*c]const f32, output: [*c]f32, len: c_int, step1: c_int, step2: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dsps_mul_f32_ae32(input1: [*c]const f32, input2: [*c]const f32, output: [*c]f32, len: c_int, step1: c_int, step2: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dsps_mul_s16_ansi(input1: [*c]const i16, input2: [*c]const i16, output: [*c]i16, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_mul_s16_ae32(input1: [*c]const i16, input2: [*c]const i16, output: [*c]i16, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_mul_s16_aes3(input1: [*c]const i16, input2: [*c]const i16, output: [*c]i16, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_mul_s8_ansi(input1: [*c]const i8, input2: [*c]const i8, output: [*c]i8, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_mul_s8_aes3(input1: [*c]const i8, input2: [*c]const i8, output: [*c]i8, len: c_int, step1: c_int, step2: c_int, step_out: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dsps_addc_f32_ansi(input: [*c]const f32, output: [*c]f32, len: c_int, C: f32, step_in: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dsps_addc_f32_ae32(input: [*c]const f32, output: [*c]f32, len: c_int, C: f32, step_in: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dsps_mulc_f32_ansi(input: [*c]const f32, output: [*c]f32, len: c_int, C: f32, step_in: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dsps_mulc_f32_ae32(input: [*c]const f32, output: [*c]f32, len: c_int, C: f32, step_in: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dsps_mulc_s16_ae32(input: [*c]const i16, output: [*c]i16, len: c_int, C: i16, step_in: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dsps_mulc_s16_ansi(input: [*c]const i16, output: [*c]i16, len: c_int, C: i16, step_in: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dsps_sqrt_f32_ansi(input: [*c]const f32, output: [*c]f32, len: c_int) sys.esp_err_t;
pub extern fn dsps_sqrtf_f32_ansi(data: f32) f32;
pub extern fn dsps_inverted_sqrtf_f32_ansi(data: f32) f32;
pub const fir_f32_t = extern struct {
    coeffs: [*c]f32 = std.mem.zeroes([*c]f32),
    delay: [*c]f32 = std.mem.zeroes([*c]f32),
    N: c_int = std.mem.zeroes(c_int),
    pos: c_int = std.mem.zeroes(c_int),
    decim: c_int = std.mem.zeroes(c_int),
    use_delay: i16 = std.mem.zeroes(i16),
};
pub const fir_s16_t = extern struct {
    coeffs: [*c]i16 = std.mem.zeroes([*c]i16),
    delay: [*c]i16 = std.mem.zeroes([*c]i16),
    coeffs_len: i16 = std.mem.zeroes(i16),
    pos: i16 = std.mem.zeroes(i16),
    decim: i16 = std.mem.zeroes(i16),
    d_pos: i16 = std.mem.zeroes(i16),
    shift: i16 = std.mem.zeroes(i16),
    rounding_buff: [*c]i32 = std.mem.zeroes([*c]i32),
    rounding_val: i32 = std.mem.zeroes(i32),
    free_status: i16 = std.mem.zeroes(i16),
};
pub extern fn dsps_fir_init_f32(fir: [*c]fir_f32_t, coeffs: [*c]f32, delay: [*c]f32, coeffs_len: c_int) sys.esp_err_t;
pub extern fn dsps_fird_init_f32(fir: [*c]fir_f32_t, coeffs: [*c]f32, delay: [*c]f32, N: c_int, decim: c_int) sys.esp_err_t;
pub extern fn dsps_fird_init_s16(fir: [*c]fir_s16_t, coeffs: [*c]i16, delay: [*c]i16, coeffs_len: i16, decim: i16, start_pos: i16, shift: i16) sys.esp_err_t;
pub extern fn dsps_fir_f32_ansi(fir: [*c]fir_f32_t, input: [*c]const f32, output: [*c]f32, len: c_int) sys.esp_err_t;
pub extern fn dsps_fir_f32_ae32(fir: [*c]fir_f32_t, input: [*c]const f32, output: [*c]f32, len: c_int) sys.esp_err_t;
pub extern fn dsps_fir_f32_aes3(fir: [*c]fir_f32_t, input: [*c]const f32, output: [*c]f32, len: c_int) sys.esp_err_t;
pub extern fn dsps_fird_f32_ansi(fir: [*c]fir_f32_t, input: [*c]const f32, output: [*c]f32, len: c_int) c_int;
pub extern fn dsps_fird_f32_ae32(fir: [*c]fir_f32_t, input: [*c]const f32, output: [*c]f32, len: c_int) c_int;
pub extern fn dsps_fird_f32_aes3(fir: [*c]fir_f32_t, input: [*c]const f32, output: [*c]f32, len: c_int) c_int;
pub extern fn dsps_fird_s16_ansi(fir: [*c]fir_s16_t, input: [*c]const i16, output: [*c]i16, len: i32) i32;
pub extern fn dsps_fird_s16_ae32(fir: [*c]fir_s16_t, input: [*c]const i16, output: [*c]i16, len: i32) i32;
pub extern fn dsps_fird_s16_aes3(fir: [*c]fir_s16_t, input: [*c]const i16, output: [*c]i16, len: i32) i32;
pub extern fn dsps_fird_s16_aexx_free(fir: [*c]fir_s16_t) sys.esp_err_t;
pub extern fn dsps_fir_f32_free(fir: [*c]fir_f32_t) sys.esp_err_t;
pub extern fn dsps_16_array_rev(arr: [*c]i16, len: i16) sys.esp_err_t;
pub extern fn dsps_biquad_f32_ansi(input: [*c]const f32, output: [*c]f32, len: c_int, coef: [*c]f32, w: [*c]f32) sys.esp_err_t;
pub extern fn dsps_biquad_f32_ae32(input: [*c]const f32, output: [*c]f32, len: c_int, coef: [*c]f32, w: [*c]f32) sys.esp_err_t;
pub extern fn dsps_biquad_f32_aes3(input: [*c]const f32, output: [*c]f32, len: c_int, coef: [*c]f32, w: [*c]f32) sys.esp_err_t;
pub extern fn dsps_biquad_gen_lpf_f32(coeffs: [*c]f32, f: f32, qFactor: f32) sys.esp_err_t;
pub extern fn dsps_biquad_gen_hpf_f32(coeffs: [*c]f32, f: f32, qFactor: f32) sys.esp_err_t;
pub extern fn dsps_biquad_gen_bpf_f32(coeffs: [*c]f32, f: f32, qFactor: f32) sys.esp_err_t;
pub extern fn dsps_biquad_gen_bpf0db_f32(coeffs: [*c]f32, f: f32, qFactor: f32) sys.esp_err_t;
pub extern fn dsps_biquad_gen_notch_f32(coeffs: [*c]f32, f: f32, gain: f32, qFactor: f32) sys.esp_err_t;
pub extern fn dsps_biquad_gen_allpass360_f32(coeffs: [*c]f32, f: f32, qFactor: f32) sys.esp_err_t;
pub extern fn dsps_biquad_gen_allpass180_f32(coeffs: [*c]f32, f: f32, qFactor: f32) sys.esp_err_t;
pub extern fn dsps_biquad_gen_peakingEQ_f32(coeffs: [*c]f32, f: f32, qFactor: f32) sys.esp_err_t;
pub extern fn dsps_biquad_gen_lowShelf_f32(coeffs: [*c]f32, f: f32, gain: f32, qFactor: f32) sys.esp_err_t;
pub extern fn dsps_biquad_gen_highShelf_f32(coeffs: [*c]f32, f: f32, gain: f32, qFactor: f32) sys.esp_err_t;
pub extern fn dsps_wind_hann_f32(window: [*c]f32, len: c_int) void;
pub extern fn dsps_wind_blackman_f32(window: [*c]f32, len: c_int) void;
pub extern fn dsps_wind_blackman_harris_f32(window: [*c]f32, len: c_int) void;
pub extern fn dsps_wind_blackman_nuttall_f32(window: [*c]f32, len: c_int) void;
pub extern fn dsps_wind_nuttall_f32(window: [*c]f32, len: c_int) void;
pub extern fn dsps_wind_flat_top_f32(window: [*c]f32, len: c_int) void;
pub extern fn dsps_conv_f32_ae32(Signal: [*c]const f32, siglen: c_int, Kernel: [*c]const f32, kernlen: c_int, convout: [*c]f32) sys.esp_err_t;
pub extern fn dsps_conv_f32_ansi(Signal: [*c]const f32, siglen: c_int, Kernel: [*c]const f32, kernlen: c_int, convout: [*c]f32) sys.esp_err_t;
pub extern fn dsps_corr_f32_ansi(Signal: [*c]const f32, siglen: c_int, Pattern: [*c]const f32, patlen: c_int, dest: [*c]f32) sys.esp_err_t;
pub extern fn dsps_corr_f32_ae32(Signal: [*c]const f32, siglen: c_int, Pattern: [*c]const f32, patlen: c_int, dest: [*c]f32) sys.esp_err_t;
pub extern fn dsps_d_gen_f32(output: [*c]f32, len: c_int, pos: c_int) sys.esp_err_t;
pub extern fn dsps_h_gen_f32(output: [*c]f32, len: c_int, pos: c_int) sys.esp_err_t;
pub extern fn dsps_tone_gen_f32(output: [*c]f32, len: c_int, Ampl: f32, freq: f32, phase: f32) sys.esp_err_t;
pub extern fn dsps_snr_f32(input: [*c]const f32, len: i32, use_dc: u8) f32;
pub extern fn dsps_snr_fc32(input: [*c]const f32, len: i32) f32;
pub extern fn dsps_sfdr_f32(input: [*c]const f32, len: i32, use_dc: i8) f32;
pub extern fn dsps_sfdr_fc32(input: [*c]const f32, len: i32) f32;
pub const bitrev2r_table_16_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev2r_table_16_fc32",
});
pub extern const bitrev2r_table_16_fc32_size: u16;
pub const bitrev2r_table_32_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev2r_table_32_fc32",
});
pub extern const bitrev2r_table_32_fc32_size: u16;
pub const bitrev2r_table_64_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev2r_table_64_fc32",
});
pub extern const bitrev2r_table_64_fc32_size: u16;
pub const bitrev2r_table_128_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev2r_table_128_fc32",
});
pub extern const bitrev2r_table_128_fc32_size: u16;
pub const bitrev2r_table_256_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev2r_table_256_fc32",
});
pub extern const bitrev2r_table_256_fc32_size: u16;
pub const bitrev2r_table_512_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev2r_table_512_fc32",
});
pub extern const bitrev2r_table_512_fc32_size: u16;
pub const bitrev2r_table_1024_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev2r_table_1024_fc32",
});
pub extern const bitrev2r_table_1024_fc32_size: u16;
pub const bitrev2r_table_2048_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev2r_table_2048_fc32",
});
pub extern const bitrev2r_table_2048_fc32_size: u16;
pub const bitrev2r_table_4096_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev2r_table_4096_fc32",
});
pub extern const bitrev2r_table_4096_fc32_size: u16;
pub extern fn dsps_fft2r_rev_tables_init_fc32() void;
pub const dsps_fft2r_rev_tables_fc32: [*c][*c]u16 = @extern([*c][*c]u16, .{
    .name = "dsps_fft2r_rev_tables_fc32",
});
pub const dsps_fft2r_rev_tables_fc32_size: [*c]const u16 = @extern([*c]const u16, .{
    .name = "dsps_fft2r_rev_tables_fc32_size",
});
pub const bitrev4r_table_16_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev4r_table_16_fc32",
});
pub extern const bitrev4r_table_16_fc32_size: u16;
pub const bitrev4r_table_32_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev4r_table_32_fc32",
});
pub extern const bitrev4r_table_32_fc32_size: u16;
pub const bitrev4r_table_64_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev4r_table_64_fc32",
});
pub extern const bitrev4r_table_64_fc32_size: u16;
pub const bitrev4r_table_128_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev4r_table_128_fc32",
});
pub extern const bitrev4r_table_128_fc32_size: u16;
pub const bitrev4r_table_256_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev4r_table_256_fc32",
});
pub extern const bitrev4r_table_256_fc32_size: u16;
pub const bitrev4r_table_512_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev4r_table_512_fc32",
});
pub extern const bitrev4r_table_512_fc32_size: u16;
pub const bitrev4r_table_1024_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev4r_table_1024_fc32",
});
pub extern const bitrev4r_table_1024_fc32_size: u16;
pub const bitrev4r_table_2048_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev4r_table_2048_fc32",
});
pub extern const bitrev4r_table_2048_fc32_size: u16;
pub const bitrev4r_table_4096_fc32: [*c]const u16 = @extern([*c]const u16, .{
    .name = "bitrev4r_table_4096_fc32",
});
pub extern const bitrev4r_table_4096_fc32_size: u16;
pub extern fn dsps_fft4r_rev_tables_init_fc32() void;
pub const dsps_fft4r_rev_tables_fc32: [*c][*c]u16 = @extern([*c][*c]u16, .{
    .name = "dsps_fft4r_rev_tables_fc32",
});
pub const dsps_fft4r_rev_tables_fc32_size: [*c]const u16 = @extern([*c]const u16, .{
    .name = "dsps_fft4r_rev_tables_fc32_size",
});
pub extern fn dsps_fft2r_init_fc32(fft_table_buff: [*c]f32, table_size: c_int) sys.esp_err_t;
pub extern fn dsps_fft2r_init_sc16(fft_table_buff: [*c]i16, table_size: c_int) sys.esp_err_t;
pub extern fn dsps_fft2r_deinit_fc32() void;
pub extern fn dsps_fft2r_deinit_sc16() void;
pub extern fn dsps_fft2r_fc32_ansi_(data: [*c]f32, N: c_int, w: [*c]f32) sys.esp_err_t;
pub extern fn dsps_fft2r_fc32_ae32_(data: [*c]f32, N: c_int, w: [*c]f32) sys.esp_err_t;
pub extern fn dsps_fft2r_fc32_aes3_(data: [*c]f32, N: c_int, w: [*c]f32) sys.esp_err_t;
pub extern fn dsps_fft2r_sc16_ansi_(data: [*c]i16, N: c_int, w: [*c]i16) sys.esp_err_t;
pub extern fn dsps_fft2r_sc16_ae32_(data: [*c]i16, N: c_int, w: [*c]i16) sys.esp_err_t;
pub extern fn dsps_fft2r_sc16_aes3_(data: [*c]i16, N: c_int, w: [*c]i16) sys.esp_err_t;
pub extern fn dsps_bit_rev_fc32_ansi(data: [*c]f32, N: c_int) sys.esp_err_t;
pub extern fn dsps_bit_rev_sc16_ansi(data: [*c]i16, N: c_int) sys.esp_err_t;
pub extern fn dsps_bit_rev2r_fc32(data: [*c]f32, N: c_int) sys.esp_err_t;
pub extern fn dsps_bit_rev_lookup_fc32_ansi(data: [*c]f32, reverse_size: c_int, reverse_tab: [*c]u16) sys.esp_err_t;
pub extern fn dsps_bit_rev_lookup_fc32_ae32(data: [*c]f32, reverse_size: c_int, reverse_tab: [*c]u16) sys.esp_err_t;
pub extern fn dsps_bit_rev_lookup_fc32_aes3(data: [*c]f32, reverse_size: c_int, reverse_tab: [*c]u16) sys.esp_err_t;
pub extern fn dsps_gen_w_r2_fc32(w: [*c]f32, N: c_int) sys.esp_err_t;
pub extern fn dsps_gen_w_r2_sc16(w: [*c]i16, N: c_int) sys.esp_err_t;
pub extern fn dsps_cplx2reC_fc32_ansi(data: [*c]f32, N: c_int) sys.esp_err_t;
pub extern fn dsps_cplx2reC_sc16(data: [*c]i16, N: c_int) sys.esp_err_t;
pub extern fn dsps_cplx2real_sc16_ansi(data: [*c]i16, N: c_int) sys.esp_err_t;
pub extern fn dsps_cplx2real256_fc32_ansi(data: [*c]f32) sys.esp_err_t;
pub extern fn dsps_gen_bitrev2r_table(N: c_int, step: c_int, name_ext: [*:0]u8) sys.esp_err_t;
pub extern var dsps_fft4r_w_table_fc32: [*c]f32;
pub extern var dsps_fft4r_w_table_size: c_int;
pub extern var dsps_fft4r_initialized: u8;
pub extern var dsps_fft4r_w_table_sc16: [*c]i16;
pub extern var dsps_fft4r_w_table_sc16_size: c_int;
pub extern var dsps_fft4r_sc16_initialized: u8;
pub extern fn dsps_fft4r_init_fc32(fft_table_buff: [*c]f32, max_fft_size: c_int) sys.esp_err_t;
pub extern fn dsps_fft4r_deinit_fc32() void;
pub extern fn dsps_fft4r_fc32_ansi_(data: [*c]f32, N: c_int, table: [*c]f32, table_size: c_int) sys.esp_err_t;
pub extern fn dsps_fft4r_fc32_ae32_(data: [*c]f32, N: c_int, table: [*c]f32, table_size: c_int) sys.esp_err_t;
pub extern fn dsps_bit_rev4r_fc32(data: [*c]f32, N: c_int) sys.esp_err_t;
pub extern fn dsps_bit_rev4r_fc32_ae32(data: [*c]f32, N: c_int) sys.esp_err_t;
pub extern fn dsps_bit_rev4r_direct_fc32_ansi(data: [*c]f32, N: c_int) sys.esp_err_t;
pub extern fn dsps_bit_rev4r_sc16_ansi(data: [*c]i16, N: c_int) sys.esp_err_t;
pub extern fn dsps_cplx2real_fc32_ansi_(data: [*c]f32, N: c_int, table: [*c]f32, table_size: c_int) sys.esp_err_t;
pub extern fn dsps_cplx2real_fc32_ae32_(data: [*c]f32, N: c_int, table: [*c]f32, table_size: c_int) sys.esp_err_t;
pub extern fn dsps_gen_bitrev4r_table(N: c_int, step: c_int, name_ext: [*:0]u8) sys.esp_err_t;
pub extern fn dsps_dct_f32(data: [*c]f32, N: c_int) sys.esp_err_t;
pub extern fn dsps_dct_inv_f32(data: [*c]f32, N: c_int) sys.esp_err_t;
pub extern fn dsps_dct_f32_ref(data: [*c]f32, N: c_int, result: [*c]f32) sys.esp_err_t;
pub extern fn dsps_dct_inverce_f32_ref(data: [*c]f32, N: c_int, result: [*c]f32) sys.esp_err_t;
pub extern fn dspm_add_f32_ansi(input1: [*c]const f32, input2: [*c]const f32, output: [*c]f32, rows: c_int, cols: c_int, padd1: c_int, padd2: c_int, padd_out: c_int, step1: c_int, step2: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dspm_add_f32_ae32(input1: [*c]const f32, input2: [*c]const f32, output: [*c]f32, rows: c_int, cols: c_int, padd1: c_int, padd2: c_int, padd_out: c_int, step1: c_int, step2: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dspm_addc_f32_ansi(input: [*c]const f32, output: [*c]f32, C: f32, rows: c_int, cols: c_int, padd_in: c_int, padd_out: c_int, step_in: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dspm_addc_f32_ae32(input: [*c]const f32, output: [*c]f32, C: f32, rows: c_int, cols: c_int, padd_in: c_int, padd_out: c_int, step_in: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dspm_mult_f32_ansi(A: [*c]const f32, B: [*c]const f32, C: [*c]f32, m: c_int, n: c_int, k: c_int) sys.esp_err_t;
pub extern fn dspm_mult_f32_ae32(A: [*c]const f32, B: [*c]const f32, C: [*c]f32, m: c_int, n: c_int, k: c_int) sys.esp_err_t;
pub extern fn dspm_mult_f32_aes3(A: [*c]const f32, B: [*c]const f32, C: [*c]f32, m: c_int, n: c_int, k: c_int) sys.esp_err_t;
pub extern fn dspm_mult_3x3x1_f32_ae32(A: [*c]const f32, B: [*c]const f32, C: [*c]f32) sys.esp_err_t;
pub extern fn dspm_mult_3x3x3_f32_ae32(A: [*c]const f32, B: [*c]const f32, C: [*c]f32) sys.esp_err_t;
pub extern fn dspm_mult_4x4x1_f32_ae32(A: [*c]const f32, B: [*c]const f32, C: [*c]f32) sys.esp_err_t;
pub extern fn dspm_mult_4x4x4_f32_ae32(A: [*c]const f32, B: [*c]const f32, C: [*c]f32) sys.esp_err_t;
pub extern fn dspm_mult_s16_ansi(A: [*c]const i16, B: [*c]const i16, C: [*c]i16, m: c_int, n: c_int, k: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dspm_mult_s16_ae32(A: [*c]const i16, B: [*c]const i16, C: [*c]i16, m: c_int, n: c_int, k: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dspm_mult_s16_aes3(A: [*c]const i16, B: [*c]const i16, C: [*c]i16, m: c_int, n: c_int, k: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dspm_mult_ex_f32_ansi(A: [*c]const f32, B: [*c]const f32, C: [*c]f32, m: c_int, n: c_int, k: c_int, A_padd: c_int, B_padd: c_int, C_padd: c_int) sys.esp_err_t;
pub extern fn dspm_mult_ex_f32_ae32(A: [*c]const f32, B: [*c]const f32, C: [*c]f32, m: c_int, n: c_int, k: c_int, A_padd: c_int, B_padd: c_int, C_padd: c_int) sys.esp_err_t;
pub extern fn dspm_mult_ex_f32_aes3(A: [*c]const f32, B: [*c]const f32, C: [*c]f32, m: c_int, n: c_int, k: c_int, A_padd: c_int, B_padd: c_int, C_padd: c_int) sys.esp_err_t;
pub extern fn dspm_mulc_f32_ansi(input: [*c]const f32, output: [*c]f32, C: f32, rows: c_int, cols: c_int, padd_in: c_int, padd_out: c_int, step_in: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dspm_mulc_f32_ae32(input: [*c]const f32, output: [*c]f32, C: f32, rows: c_int, cols: c_int, padd_in: c_int, padd_out: c_int, step_in: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dspm_sub_f32_ansi(input1: [*c]const f32, input2: [*c]const f32, output: [*c]f32, rows: c_int, cols: c_int, padd1: c_int, padd2: c_int, padd_out: c_int, step1: c_int, step2: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dspm_sub_f32_ae32(input1: [*c]const f32, input2: [*c]const f32, output: [*c]f32, rows: c_int, cols: c_int, padd1: c_int, padd2: c_int, padd_out: c_int, step1: c_int, step2: c_int, step_out: c_int) sys.esp_err_t;
pub extern fn dsps_view(data: [*c]const f32, len: i32, width: c_int, height: c_int, min: f32, max: f32, view_char: u8) void;
pub extern fn dsps_view_s16(data: [*c]const i16, len: i32, width: c_int, height: c_int, min: f32, max: f32, view_char: u8) void;
pub extern fn dsps_view_spectrum(data: [*c]const f32, len: i32, min: f32, max: f32) void;
pub extern fn dspi_dotprod_f32_ansi(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*c]f32, count_x: c_int, count_y: c_int) sys.esp_err_t;
pub extern fn dspi_dotprod_s16_ansi(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*c]i16, count_x: c_int, count_y: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dspi_dotprod_u16_ansi(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*c]u16, count_x: c_int, count_y: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dspi_dotprod_s8_ansi(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*c]i8, count_x: c_int, count_y: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dspi_dotprod_u8_ansi(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*:0]u8, count_x: c_int, count_y: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dspi_dotprod_s16_aes3(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*c]i16, count_x: c_int, count_y: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dspi_dotprod_u16_aes3(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*c]u16, count_x: c_int, count_y: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dspi_dotprod_s8_aes3(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*c]i8, count_x: c_int, count_y: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dspi_dotprod_u8_aes3(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*:0]u8, count_x: c_int, count_y: c_int, shift: c_int) sys.esp_err_t;
pub extern fn dspi_dotprod_off_f32_ansi(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*c]f32, count_x: c_int, count_y: c_int, offset: f32) sys.esp_err_t;
pub extern fn dspi_dotprod_off_s16_ansi(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*c]i16, count_x: c_int, count_y: c_int, shift: c_int, offset: i16) sys.esp_err_t;
pub extern fn dspi_dotprod_off_u16_ansi(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*c]u16, count_x: c_int, count_y: c_int, shift: c_int, offset: u16) sys.esp_err_t;
pub extern fn dspi_dotprod_off_s8_ansi(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*c]i8, count_x: c_int, count_y: c_int, shift: c_int, offset: i8) sys.esp_err_t;
pub extern fn dspi_dotprod_off_u8_ansi(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*:0]u8, count_x: c_int, count_y: c_int, shift: c_int, offset: u8) sys.esp_err_t;
pub extern fn dspi_dotprod_off_s16_aes3(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*c]i16, count_x: c_int, count_y: c_int, shift: c_int, offset: i16) sys.esp_err_t;
pub extern fn dspi_dotprod_off_u16_aes3(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*c]u16, count_x: c_int, count_y: c_int, shift: c_int, offset: u16) sys.esp_err_t;
pub extern fn dspi_dotprod_off_s8_aes3(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*c]i8, count_x: c_int, count_y: c_int, shift: c_int, offset: i8) sys.esp_err_t;
pub extern fn dspi_dotprod_off_u8_aes3(in_image: [*c]image2d_t, filter: [*c]image2d_t, out_value: [*:0]u8, count_x: c_int, count_y: c_int, shift: c_int, offset: u8) sys.esp_err_t;
