#include "driver/gpio.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "soc/gpio_num.h"
#include <cstdio>
#include <expected>
#include <string>

// GPIO Pin configuration
#ifndef CONFIG_BLINK_GPIO
constexpr auto BLINK_GPIO = GPIO_NUM_2;
#else
constexpr auto BLINK_GPIO = CONFIG_BLINK_GPIO;
#endif

// Function to blink LED
std::expected<void, std::string> blinkLED(int delay_ms) {
  gpio_set_direction(BLINK_GPIO, GPIO_MODE_OUTPUT);

  while (true) {
    gpio_set_level(BLINK_GPIO, 1); // LED ON
    vTaskDelay(delay_ms / portTICK_PERIOD_MS);
    gpio_set_level(BLINK_GPIO, 0); // LED OFF
    vTaskDelay(delay_ms / portTICK_PERIOD_MS);
  }

  return {};
}

extern "C" void app_main() {
  // Create a task for blinking LED
  xTaskCreate(
      [](void *pvParameter) {
        std::expected<void, std::string> result =
            blinkLED(1000); // Blink every 1 second

        if (!result) {
          std::printf("Error: %s\n", result.error().c_str());
        }
      },
      "blink_task", 2048, nullptr, 5, nullptr);
}
