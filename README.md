# swift-quantizer

Use this package when a floating-point value must snap to a uniform grid of step `quantum` (prices in cents, coordinates on a pixel grid, durations in ticks), or be stored as an integer count of grid steps and recovered from it. Start from `Quantizer<Scalar>`; when the step is a fixed property of a type, conform that type to `Quantized`. To round to whole numbers without a grid, use `Rounding` from swift-rounding directly.

## Laws

- Quantizing `value` is `rounding(value / quantum) * quantum` in `Scalar` arithmetic: the rounding policy applies to the grid coordinate, not to the value. The default policy is `Rounding.nearest(.away)`, so ties move away from zero; the sign of zero is preserved.
- A value already on the grid maps to itself (pinned for a dyadic quantum such as 0.25).
- There is no implicit integer width. Quantizing a value never passes through an integer, so values beyond `Int64` quantize; the integer width appears only when the caller asks for ticks, and the tick count must fit that type exactly.
- Failures, by condition: a quantum that is zero, negative, NaN or infinite is `Quantizer<Scalar>.Error.invalidQuantum`; a NaN or infinite input is `Quantizer<Scalar>.Error.nonfinite`; a coordinate, grid value or tick count that overflows `Scalar` or the requested integer type is `Quantizer<Scalar>.Error.outOfRange`; any failure of the rounding policy (for `Rounding.exact`, a value off the grid) is `Quantizer<Scalar>.Error.inexact`.
- `Quantized.quantize(_:)` always uses the default rounding policy and validates the type's quantum on every call; nothing is cached.
