#include <benchmark/benchmark.h>
#include <cstddef>
#include <tribo.h>

void triboDomainSet(benchmark::State& state) {
	constexpr double xin = -1.0;
	constexpr double xout = -1.0;
	constexpr size_t xn = 10;

	for ([[maybe_unused]] auto iter : state) {
		auto const* result = triboDomainSet(xin, xout, xn, nullptr);
		benchmark::DoNotOptimize(result);
		triboDomainFree(&result);
	}
}

BENCHMARK(triboDomainSet);
