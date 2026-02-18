# Getting Started with Zig ESP-IDF Sample

A complete guide to building ESP32 firmware using Zig and ESP-IDF.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Building Your First Project](#building-your-first-project)
- [Working with Components](#working-with-components)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)

---

## Prerequisites

### Required Software

- **Python 3.12+** (for ESP-IDF tools)
- **Git** (for cloning repositories)
- **CMake 3.16+** (bundled with ESP-IDF)
- **Ninja** or **Make** (bundled with ESP-IDF)
- **Zig compiler** (optional - will be auto-downloaded if not found)

### Supported Operating Systems

- **Linux** (Ubuntu 20.04+, Debian, Fedora, Arch)
- **macOS** (10.15+)
- **Windows** (10/11 with PowerShell or WSL2)
- **Nix/NixOS** (via `flake.nix`)

### Supported ESP32 Targets

| Architecture | Targets |
|--------------|---------|
| **RISC-V** | ESP32-C2, C3, C5, C6, C61, H2, H21, H4, P4 |
| **Xtensa** | ESP32, ESP32-S2, ESP32-S3 |

---

## Installation

### Step 1: Install ESP-IDF

**Option A: Standard Installation**

```bash
# Clone ESP-IDF
git clone --recursive https://github.com/espressif/esp-idf.git
cd esp-idf

# Linux/macOS:
./install.sh

# Windows (PowerShell):
.\install.ps1

# Windows (Command Prompt):
install.bat
```

**Option B: Using Nix Flakes** (Linux/macOS)

```bash
# Enter development environment with all dependencies
nix develop

# Or use direnv for automatic activation
echo "use flake" > .envrc
direnv allow
```

**Option C: ESP-IDF installer** (Windows/macOS)

Download from: https://dl.espressif.com/dl/esp-idf/

### Step 2: Set up ESP-IDF Environment

Every time you open a new terminal, activate ESP-IDF:

```bash
# Linux/macOS:
. $HOME/esp/esp-idf/export.sh

# Windows (PowerShell):
. $HOME/esp/esp-idf/export.ps1

# Windows (Command Prompt):
%USERPROFILE%\esp\esp-idf\export.bat
```

### Step 3: Clone This Project

```bash
git clone https://github.com/kassane/zig-esp-idf-sample.git
cd zig-esp-idf-sample
```

### Step 4: Verify Installation

```bash
idf.py --version
# Expected output: ESP-IDF v5.x.x or v6.x.x
```

---

## Quick Start

### 1. Set Your Target Device

```bash
# For ESP32-C6 (RISC-V)
idf.py set-target esp32c6

# For ESP32-S3 (Xtensa)
idf.py set-target esp32s3

# For ESP32 (original, Xtensa)
idf.py set-target esp32
```

### 2. Build the Project

```bash
idf.py build
```

**What happens during build:**
- ✅ CMake detects your target and configures the build
- ✅ Zig toolchain is automatically downloaded (if needed)
- ✅ C bindings are generated from ESP-IDF headers
- ✅ Target-specific patches are applied
- ✅ Zig code is compiled to object files
- ✅ Everything is linked with ESP-IDF libraries
- ✅ Firmware binaries are generated

### 3. Flash to Device

```bash
# Connect your ESP32 via USB, then:
idf.py -p PORT flash

# Find your port:
# Linux: /dev/ttyUSB0 or /dev/ttyACM0
# macOS: /dev/cu.usbserial-*
# Windows: COM3, COM4, etc.

# Example:
idf.py -p /dev/ttyUSB0 flash
```

### 4. Monitor Output

```bash
idf.py -p PORT monitor

# Or combine flash + monitor:
idf.py -p PORT flash monitor

# Exit monitor: Ctrl+]
```

---

## Project Structure

```
zig-esp-idf-sample/
├── build.zig              # Zig build script (compiles Zig code)
├── build.zig.zon          # Zig package manifest
├── CMakeLists.txt         # Root CMake config
├── sdkconfig              # ESP-IDF configuration (generated)
├── sdkconfig.defaults     # Default SDK config
├── sdkconfig.defaults.esp32  # ESP32-specific defaults
├── dependencies.lock      # Component version lock
├── wokwi.toml            # Wokwi simulator config
│
├── main/
│   ├── CMakeLists.txt    # Main component config
│   ├── placeholder.c     # Minimal C entry point
│   ├── app.zig           # Main Zig application entry
│   ├── idf_component.yml # Component dependencies
│   ├── Kconfig.projbuild # Project configuration options
│   └── examples/
│       ├── smartled-rgb.zig   # LED strip (WS2812B) example
│       └── wifi-station.zig   # WiFi station example
│
├── imports/              # Zig API wrappers and bindings
│   ├── idf.zig           # Main ESP-IDF facade module
│   ├── idf-sys.zig       # Generated C bindings (auto-generated)
│   ├── gpio.zig          # GPIO wrapper
│   ├── wifi.zig          # WiFi wrapper
│   ├── bluetooth.zig     # Bluetooth wrapper
│   ├── heap.zig          # Memory allocators
│   ├── rtos.zig          # FreeRTOS wrappers
│   ├── led-strip.zig     # LED strip API
│   ├── i2c.zig           # I2C communication
│   ├── spi.zig           # SPI communication
│   ├── uart.zig          # UART communication
│   ├── i2s.zig           # I2S audio
│   ├── http.zig          # HTTP client/server
│   ├── mqtt.zig          # MQTT client
│   ├── lwip.zig          # LwIP TCP/IP stack
│   ├── dsp.zig           # Digital Signal Processing
│   ├── pcnt.zig          # Pulse Counter
│   ├── error.zig         # Error handling utilities
│   ├── logger.zig        # Logging utilities
│   ├── panic.zig         # Panic handler
│   └── version.zig       # Version information
│
├── include/              # C headers for binding generation
│   ├── stubs.h           # Core ESP-IDF headers
│   ├── wifi_stubs.h      # WiFi-specific headers
│   └── bindings.h        # Additional bindings
│
├── cmake/               # CMake build system scripts
│   ├── zig-config.cmake        # Main Zig configuration
│   ├── zig-download.cmake      # Auto-download Zig toolchain
│   ├── zig-runner.cmake        # Helper functions for Zig
│   ├── bindings.cmake          # Binding generation
│   ├── extra-components.cmake  # Managed component detection
│   └── patch.cmake             # Post-processing patches
│
├── patches/             # Binding fixes for translate-c issues
│   ├── *.zig
│
├── docs/                # Documentation
│   ├── build-internals.md      # Build system details
│   ├── build-scheme.png        # Build flow diagram
│   └── zig-xtensa.md           # Xtensa toolchain info
│
└── flake.nix            # Nix development environment
```

---

## Building Your First Project

### Example 1: Hello World

```zig
const std = @import("std");
const idf = @import("esp_idf");

comptime {
    @export(&main, .{ .name = "app_main" });
}

fn main() callconv(.c) void {
    log.info("Hello from Zig on ESP32!", .{});
    log.info("Zig version: {s}", .{@import("builtin").zig_version_string});
    
    // Show memory info
    var heap = idf.heap.HeapCapsAllocator.init(null); // default: MALLOC_CAP_DEFAULT
    log.info("Free heap: {} bytes", .{heap.freeSize()});
    
    // Sleep forever
    while (true) {
        idf.rtos.Task.delayMs(1000);
    }
}

// overwrite zig std_options config
pub const std_options: std.Options = .{
    .logFn = idf.log.espLogFn,
};
// rename log instance
const log = std.log.scoped(.@"esp-idf");
// overwrite std panic-handler
pub const panic = idf.esp_panic.panic;
```

**Build and run:**
```bash
idf.py build flash monitor
```

### Example 2: Blinking LED

**Create `main/examples/blink.zig`:**

```zig
const std = @import("std");
const idf = @import("esp_idf");

const LED_PIN = .@"18"; // Change to your LED pin

comptime {
    @export(&main, .{ .name = "app_main" });
}

fn main() callconv(.c) void {    
    // Configure GPIO as output
    idf.gpio.Direction.set(LED_PIN, .output) catch {
        log.err("Failed to configure GPIO", .{});
        return;
    };
    
    log.info("Blinking LED on GPIO {d}", .{LED_PIN});
    
    while (true) {
        // LED ON
        idf.gpio.Level.set(LED_PIN, 1) catch {};
        log.info("LED ON", .{});
        idf.rtos.Task.delayMs(1000);
        
        // LED OFF
        idf.gpio.Level.set(LED_PIN, 0) catch {};
        log.info("LED OFF", .{});
        idf.rtos.Task.delayMs(1000);
    }
}

// overwrite zig std_options config
pub const std_options: std.Options = .{
    .logFn = idf.log.espLogFn,
};
// rename log instance
const log = std.log.scoped(.blink);
// overwrite std panic-handler
pub const panic = idf.esp_panic.panic;
```

---

## Working with Components

### Adding Managed Components

Components are specified in `main/idf_component.yml`:

**Add a component:**

```bash
# Use idf.py command:
idf.py add-dependency espressif/led_strip
# then
idf.py reconfigure
```

### Using LED Strip Component

**The build system automatically:**
1. ✅ Detects components in `dependencies.lock`
2. ✅ Adds include paths to binding generation
3. ✅ Generates `HAS_*` defines (e.g., `HAS_LED_STRIP=1`)
4. ✅ Includes headers in `include/stubs.h` conditionally
5. ✅ Makes APIs available in Zig via `idf.*` modules

**1. Ensure LED strip is in `main/idf_component.yml`:**
```yaml
dependencies:
  espressif/led_strip: "*"
```

**2. Reconfigure:**
```bash
idf.py reconfigure
```

**3. Check provided example:**

The example in [examples/smartled-rgb.zig](../main/examples/smartled-rgb.zig) demonstrates:
- Configuring WS2812B LED strip on GPIO 2
- Setting individual pixel colors
- Refreshing the display
- Blinking pattern

### DSP basics (FFT + math)

[examples/dsp-math.zig](../main/examples/dsp-math.zig)

- Generates a sine tone (freq = 0.2 normalized)
- Applies Hann window
- Does FFT (1024 points, float32, radix-2)
- Computes power spectrum in dB
- Prints ASCII plot of the spectrum (64×10 chars, -120 to +40 dB)

### Using WiFi

**Use the WiFi station example:**
[examples/wifi-station.zig](../main/examples/wifi-station.zig)

**Configure WiFi credentials:**

```bash
idf.py menuconfig
# Navigate to: Example Configuration
# Set WiFi SSID and Password
```

Or edit [main/Kconfig.projbuild](../main/Kconfig.projbuild) to change default values.

### Available Wrapper APIs

The project provides comprehensive Zig wrappers in `imports/`:

| Module | Description | Example Usage |
|--------|-------------|---------------|
| `idf.gpio` | GPIO control | `idf.gpio.Level.set(.GPIO_NUM_18, 1)` |
| `idf.wifi` | WiFi connectivity | `idf.wifi.init()` |
| `idf.bt` | Bluetooth/BLE | `idf.bt.*` |
| `idf.heap` | Memory allocators | `idf.heap.HeapCapsAllocator` |
| `idf.rtos` | FreeRTOS tasks | `idf.rtos.*` |
| `idf.led` | LED strip (WS2812B) | `idf.led.*` (requires led-strip) |
| `idf.i2c` | I2C communication | `idf.i2c.*` |
| `idf.spi` | SPI communication | `idf.spi.*` |
| `idf.uart` | UART serial | `idf.uart.*` |
| `idf.i2s` | I2S audio | `idf.i2s.*` |
| `idf.http` | HTTP client/server | `idf.http.*` |
| `idf.mqtt` | MQTT client | `idf.mqtt.*` |
| `idf.lwip` | TCP/IP stack | `idf.lwip.*` |
| `idf.dsp` | DSP functions | `idf.dsp.*` (requires esp-dsp) |
| `idf.pulse` | Pulse counter | `idf.pulse.*` |
| `idf.log` | Logging utilities | `idf.log.espLogFn` |
| `idf.err` | Error handling | `idf.err.espCheckError()` |
| `idf.sys` | Raw C bindings | Direct ESP-IDF API access |

---

## Examples

### FreeRTOS Tasks

```zig
const idf = @import("esp_idf");
const std = @import("std");

// overwrite std panic-handler
pub const panic = idf.esp_panic.panic;
// overwrite std.log
pub const std_options: std.Options = .{
    .logFn = idf.log.espLogFn,
};

export fn myTask(_: ?*anyopaque) callconv(.c) void {
    const log = std.log.scoped(.task);
    while (true) {
        log.info("Task running!", .{});
        idf.rtos.Task.delayMs(1000);
    }
}

export fn app_main() callconv(.c) void {
    _ = idf.rtos.Task.create(myTask, "my_task", 2048, null, 5) catch @panic("Failed to create task");
    
    // Main task continues...
    while (true) {
        idf.rtos.Task.delayMs(1000);
    }
}
```

### Using Custom Allocators

```zig
const idf = @import("esp_idf");
const std = @import("std");

export fn app_main() callconv(.c) void {
    var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena.deinit();
    
    const allocator = arena.allocator();
    
    var list: std.ArrayList(u32) = .empty;
    defer list.deinit(allocator);
    
    list.append(allocator, 10) catch {};
    list.append(allocator, 20) catch {};
    list.append(allocator, 30) catch {};
    
    // ...
}
```

### Accessing Raw C APIs

When wrappers aren't available, use raw bindings:

```zig
const idf = @import("esp_idf");
const std = @import("std");
const sys = idf.sys;
const log = std.log.scoped(.@"esp-idf");

export fn app_main() callconv(.c) void {
    var mac_addr: [6]u8 = undefined;
    
    // Direct ESP-IDF C API call
    const result = sys.esp_efuse_mac_get_default(&mac_addr);
    if (result != sys.ESP_OK) {
        std.log.err("Failed to get MAC address", .{});
        return;
    }
    
    log.info("MAC: {X:0>2}:{X:0>2}:{X:0>2}:{X:0>2}:{X:0>2}:{X:0>2}", .{
        mac_addr[0], mac_addr[1], mac_addr[2],
        mac_addr[3], mac_addr[4], mac_addr[5],
    });
}

pub const std_options: std.Options = .{
    .logFn = idf.log.espLogFn,
};
```

---

## Troubleshooting

### Build Errors

**"zig: command not found"**
- The Zig toolchain should auto-download. Check `build/zig-relsafe-*` directory
- Or install manually: https://ziglang.org/download/
- For Nix users: `nix develop`

**"Component not found: espressif__led_strip"**
```bash
# Check idf_component.yml
cat main/idf_component.yml

# Reconfigure to download components
idf.py reconfigure
```

**"translate-c failed"**
- Check `include/stubs.h` and `include/wifi_stubs.h` for syntax errors
- Ensure managed components exist in `managed_components/`
- Check that `HAS_*` defines match components in `cmake/extra-components.cmake`

**Binding generation errors**
- The `patches/` directory contains fixes for common `translate-c` issues
- If you see struct layout errors, a patch likely needs updating
- Check `cmake/patch.cmake` for how patches are applied

### Flash Errors

**"Serial port not found"**
```bash
# Linux: Add user to dialout group
sudo usermod -a -G dialout $USER
# Log out and back in

# Check available ports
ls /dev/tty*

# Windows: Check Device Manager for COM port
```

**"Failed to connect to ESP32"**
- Hold BOOT button while connecting
- Try different USB cable/port (must be data cable, not power-only)
- Verify target matches your device: `idf.py set-target esp32c6`
- Check USB drivers are installed (CP210x or CH340)

### Runtime Errors

**"Guru Meditation Error: Core panic"**
- Check stack size (increase in `xTaskCreate`, default 2048 often too small)
- Verify GPIO pins match your hardware
- Enable debug build: `idf.py menuconfig` → Compiler options → Debug (-Og)
- Check `sdkconfig` for panic handler settings

**"Out of memory" / Heap errors**
- Use arena allocators: `std.heap.ArenaAllocator`
- Check available heap: `heap.freeSize()`
- Reduce allocations in hot paths
- Consider enabling PSRAM if available
- Check `idf.py size-components` for memory usage

**WiFi not connecting**
- Verify SSID and password in menuconfig
- Check WiFi country code matches your region
- Ensure 2.4GHz WiFi (5GHz not supported)
- Check WiFi credentials don't contain special characters

---

## Next Steps

### Learn More

- **Zig Language:** https://ziglang.org/documentation/master/
- **ESP-IDF Docs:** https://docs.espressif.com/projects/esp-idf/
- **Project Wiki:** 
  - [Build Internals](./build-internals.md)
  - [Xtensa Toolchain](./zig-xtensa.md)

### Explore Examples

All examples are in `main/examples/`:
- `smartled-rgb.zig` - WS2812B LED strip control
- `wifi-station.zig` - Connect to WiFi network

### Configuration

```bash
# Interactive configuration menu
idf.py menuconfig

# Key settings to explore:
# - Component config → FreeRTOS → Tick rate (Hz)
# - Component config → ESP System Settings → Panic handler behavior
# - Partition Table → Choose partition scheme
# - Example Configuration → WiFi credentials
# - Compiler options → Optimization level
```

### Testing with Wokwi Simulator

The project includes `wokwi.toml` for simulation:

1. Install Wokwi CLI: https://docs.wokwi.com/wokwi-ci/idf-wokwi-usage
2. Edit `wokwi.toml` to match your project
3. Run: `idf.py wokwi --timeout 30000`

or use VSCode Extension

* More info: https://docs.wokwi.com/vscode/getting-started

### Advanced Topics

- **Custom Components:** Create reusable Zig modules in `imports/`
- **WiFi & Networking:** HTTP servers, WebSockets, mDNS
- **OTA Updates:** Over-the-air firmware updates
- **Bluetooth:** BLE advertising, GATT services
- **Deep Sleep:** Ultra-low power modes
- **File Systems:** SPIFFS, FAT, LittleFS
- **Cryptography:** Hardware-accelerated crypto

### Development Tips

**Use `sdkconfig.defaults` for version control:**
- Base config: `sdkconfig.defaults`
- Target-specific: `sdkconfig.defaults.esp32`
- Don't commit `sdkconfig` (it's generated)

**Debugging:**
```bash
# Monitor with timestamps
idf.py monitor --timestamps

# Filter logs by tag
idf.py monitor --print-filter "tag:app"

# Save logs to file
idf.py monitor | tee output.log
```

**Clean builds when needed:**
```bash
# Clean Zig cache
rm -rf .zig-cache

# Full CMake clean
idf.py fullclean

# Regenerate bindings
idf.py reconfigure
```

### Contributing

Found a bug or want to contribute?
- **GitHub:** https://github.com/kassane/zig-esp-idf-sample
- **Issues:** https://github.com/kassane/zig-esp-idf-sample/issues
- **Pull Requests:** See [CONTRIBUTING.md](../CONTRIBUTING.md)

---

## Quick Reference

### Common Commands

```bash
# Setup
idf.py set-target esp32c6        # Set target device
idf.py reconfigure                # Regenerate build config / update deps

# Build
idf.py build                      # Build project
idf.py clean                      # Clean build files
idf.py fullclean                  # Full clean (including config)

# Flash
idf.py -p PORT flash              # Flash firmware
idf.py -p PORT monitor            # Monitor serial output
idf.py -p PORT flash monitor      # Flash and monitor
idf.py -p PORT app-flash          # Flash app only (faster)

# Config
idf.py menuconfig                 # Interactive configuration
idf.py size                       # Show binary sizes
idf.py size-components            # Component size breakdown

# Dependencies
idf.py add-dependency PKG         # Add managed component

# Help
idf.py --help                     # Show all commands
idf.py --list-targets             # List supported targets
```

### File Locations

- **Main app:** `main/app.zig`
- **Examples:** `main/examples/*.zig`
- **Dependencies:** `main/idf_component.yml`
- **Configuration:** `sdkconfig`, `sdkconfig.defaults*`
- **Bindings:** `imports/idf-sys.zig` (auto-generated)
- **Wrappers:** `imports/*.zig`
- **Build scripts:** `cmake/*.cmake`

### Pin Configuration

Check your board's pinout:
- **GPIO Pins:** Varies by model (ESP32: 0-39, ESP32-C6: 0-30)
- **Built-in LED:** Often GPIO 2, 8, or 18
- **UART:** Usually GPIO 1 (TX), GPIO 3 (RX)
- **I2C:** SDA/SCL pins vary by board
- **SPI:** MOSI/MISO/CLK pins vary by board

### Hardware Requirements

- **ESP32 Development Board** (any supported variant)
- **USB Cable** (must be data cable, not power-only)
- **LEDs/Components** (optional, for examples)
- **LED Strip WS2812B** (optional, for smartled-rgb example)

---

## Support

- **Documentation:** [docs/](.)
- **Issues:** https://github.com/kassane/zig-esp-idf-sample/issues
- **Discussions:** https://github.com/kassane/zig-esp-idf-sample/discussions
