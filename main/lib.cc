#include <cstdio>
#include <expected>
#include <format>
#include <string>
#include <vector>

consteval double
add(const double a, const double b)
{
  return a + b;
}

std::expected<int, std::string>
divide(int numerator, int denominator)
{
  if (denominator == 0) {
    return std::unexpected("Division by zero");
  }
  return numerator / denominator;
}

std::expected<std::vector<int>, std::string>
generateVector(int size)
{
  if (size < 0) {
    return std::unexpected("Size cannot be negative.");
  }

  std::vector<int> vec(size);
  for (int i = 0; i < size; ++i) {
    vec[i] = i;
  }

  return vec;
}

extern "C"
{
  void app_main(void)
  {
    const auto hello = std::format("Add 6 + 7.5 = {}\n", add(6, 7.5));
    std::printf(hello.c_str());
    auto result = generateVector(5);

    if (result) {
      std::printf("Vector generated successfully:\n");
      for (int num : *result) {
        std::printf("%d ", num);
      }
      std::printf("\n");
    } else {
      std::printf("Failed to generate vector: %s\n", result.error().c_str());
    }
  }
}
