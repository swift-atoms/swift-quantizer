extension Quantizer {

    public enum Error: Swift.Error, Sendable, Equatable {
        case invalidQuantum
        case nonfinite
        case outOfRange
        case inexact
    }
}
