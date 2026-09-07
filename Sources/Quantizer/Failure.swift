/// Quantization failures are independent of scalar representation.
public enum Failure: Swift.Error, Sendable, Equatable {
    case invalidQuantum
    case nonfinite
    case outOfRange
    case inexact
}
