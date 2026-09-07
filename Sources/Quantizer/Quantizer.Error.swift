extension Quantizer {
    /// Failures in grid validation, quantization, or explicit storage conversion.
    public enum Error: Swift.Error, Sendable, Equatable {
        case invalidQuantum
        case nonfinite
        case outOfRange
        case inexact
    }
}
