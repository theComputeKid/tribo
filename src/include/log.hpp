/**
 * @file
 * @brief Logging utilities.
 */
#pragma once
#include <source_location>
#include <string_view>

namespace tribo {
  auto setLogVerbosity(unsigned int verbosity) -> void;
  auto logInfoMsg(std::string_view msg, std::source_location const& loc = std::source_location::current()) -> void;
  auto logErrorMsg(std::string_view msg, std::source_location const& loc = std::source_location::current()) -> void;
} // namespace tribo
