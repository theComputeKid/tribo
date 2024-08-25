#include <benchmark/benchmark.h>
#include <tribo.h>

namespace tribo::test {

  void getInfoVersionMajor(benchmark::State& state) {
    for ([[maybe_unused]] auto iter : state) {
      auto result = triboGetInfoVersionMajor();
      benchmark::DoNotOptimize(result);
    }
  }

  BENCHMARK(getInfoVersionMajor);

  void getInfoVersionMinor(benchmark::State& state) {
    for ([[maybe_unused]] auto iter : state) {
      auto result = triboGetInfoVersionMinor();
      benchmark::DoNotOptimize(result);
    }
  }

  BENCHMARK(getInfoVersionMinor);

  void getInfoVersionPatch(benchmark::State& state) {
    for ([[maybe_unused]] auto iter : state) {
      auto result = triboGetInfoVersionPatch();
      benchmark::DoNotOptimize(result);
    }
  }

  BENCHMARK(getInfoVersionPatch);

} // namespace tribo::test
