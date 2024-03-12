#include <cstdio>
#include <format>
// #include <print> // not founded

consteval double
add(const double a, const double b)
{
  return a + b;
}

extern "C"
{
  void app_main(void)
  {
    const auto hello = std::format("\nAdd 6 + 7.5 = {}\n", add(6, 7.5));
    std::printf(hello.c_str());
  }
}
