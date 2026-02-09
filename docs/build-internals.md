## How does the mixin build-system work?

#### Intro

ESP-IDF uses `idf.py` script is a wrapper around CMake and is responsible for creating the build environment and running CMake to generate the build files, with ninja to build the project.
However, zig build-system (`build.zig`) is a wrapper around the zig compiler.

For more details about zig commands, see [doc/zig-xtensa](zig-xtensa.md)

#### Building this project

After cloning this project, you need to install ESP-IDF and set up the environment:

1. Install ESP-IDF by following the official guide:
   - Clone ESP-IDF repository: `git clone --recursive https://github.com/espressif/esp-idf.git`
   - Run the installation script:
     - Windows: `install.bat`|`install.ps1`
     - Posix: `./install.sh`

2. Set up the ESP-IDF environment variables:
   - Windows: run `export.bat`|`./export.ps1`
   - Posix: `. ./export.sh`

   Once the environment is set up, you can build the project using this scheme:

   ![](build-scheme.png)


3. Set the target ESP device (if not already set):
   
   ```bash
   idf.py set-target (esp-device)
   ```
   Supported targets: esp32, esp32s2, esp32s3, esp32c3, esp32h2, esp32c2, esp32c6, esp32p4

4. Build the project:
   ```bash
   idf.py build
   ```
   
5. Flash the firmware to your device:
   ```bash
   idf.py -p PORT flash
   ```   
   Replace PORT with your device's serial port (e.g., COM3 on Windows or /dev/ttyUSB0 on Linux)

6. Monitor the device output:
   ```bash
   idf.py monitor
   ```
Additional useful commands:
- Clean the project: `idf.py clean`
- Full clean and rebuild: `idf.py fullclean`
- Build and flash in one command: `idf.py -p PORT flash monitor`
- Show all targets: `idf.py --list-targets`
- Configure project: `idf.py menuconfig`


### Current role of `build.zig`

Since the latest refactors (post [#37](https://github.com/kassane/zig-esp-idf-sample/pull/37) and related CMake changes), `build.zig` is **focused exclusively on Zig code**:

- Defines Zig modules:
  - `esp_idf` → facade module that re-exports safe wrappers from `imports/*.zig` (gpio, wifi, heap, rtos, etc.)
  - `sys` → low-level module that imports the generated `idf-sys.zig` (raw C bindings)
- Collects and links Zig sources
- Uses pre-generated includes/dependencies from CMake (no more manual `includeDeps` or searching IDF libs/objects in `build.zig`)
- Avoids duplicate imports (use `esp_idf` as the main entry point)

**Old responsibilities moved to CMake**:
- Searching/appending IDF object files → `.a` libs (now handled by IDF CMake)
- Manually collecting includes from IDF components → automatic via CMake
- Running `translate-c` in **stubs.h** to `idf-sys.zig` generate, patches → fully in `cmake/` scripts (`zig-config.cmake`, `zig-download.cmake`, `patch.cmake`)
- Switching Zig (**upstream** x **espressif**) by target. If have installed zig-upstream use for **RISC-V** targets (*except P4 & H4*)

This separation makes the project cleaner:
- CMake handles the complex C/ESP-IDF world (toolchain, bindings generation)
- Zig handles only modern, safe, comptime-friendly code

For advanced users: see `zig-config.cmake` and `cmake/patch.cmake` for how `idf-sys.zig` is generated and refined before Zig sees it.
