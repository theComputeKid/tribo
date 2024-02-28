#include <benchmark/benchmark.h>
#include <tribo.h>

void triboInfoVersionMajor(benchmark::State& state) {
	for ([[maybe_unused]] auto iter : state) {
		auto result = triboInfoVersionMajor();
		benchmark::DoNotOptimize(result);
	}
}

BENCHMARK(triboInfoVersionMajor);

void triboInfoVersionMinor(benchmark::State& state) {
	for ([[maybe_unused]] auto iter : state) {
		auto result = triboInfoVersionMinor();
		benchmark::DoNotOptimize(result);
	}
}

BENCHMARK(triboInfoVersionMinor);

void triboInfoVersionPatch(benchmark::State& state) {
	for ([[maybe_unused]] auto iter : state) {
		auto result = triboInfoVersionPatch();
		benchmark::DoNotOptimize(result);
	}
}

BENCHMARK(triboInfoVersionPatch);
