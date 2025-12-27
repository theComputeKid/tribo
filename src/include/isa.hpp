#pragma once
#include "arch.hpp"
#include <cstdint>

namespace tribo {
#ifdef TRIBO_X64
  enum class ISA : std::uint8_t { BASE, AVX, AVX512, AUTO };
#elifdef TRIBO_ARM64_MACOS
  enum class ISA : std::uint8_t { BASE, NEON, AUTO };
#elifdef TRIBO_ARM64
  enum class ISA : std::uint8_t { BASE, NEON, SVE2, AUTO };
#endif

  auto detectISA(ISA isa) -> bool;
  auto detectAutoISA() -> ISA;
} // namespace tribo
