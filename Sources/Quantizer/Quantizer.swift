public import Rounding


public struct Quantizer<Scalar: BinaryFloatingPoint> {
    public let quantum: Scalar
    public let rounding: Rounding

    public init(quantum: Scalar, rounding: Rounding = .nearest(.away)) throws(Error) {
        guard quantum.isFinite, quantum > 0 else { throw .invalidQuantum }
        self.quantum = quantum
        self.rounding = rounding
    }


    public func coordinate(for value: Scalar) throws(Error) -> Scalar {
        guard value.isFinite else { throw .nonfinite }
        let coordinate = value / quantum
        guard coordinate.isFinite else { throw .outOfRange }
        do { return try rounding(coordinate) }
        catch { throw .inexact }
    }

    public func callAsFunction(_ value: Scalar) throws(Error) -> Scalar {
        let result = try coordinate(for: value) * quantum
        guard result.isFinite else { throw .outOfRange }
        return result
    }


    public func ticks<T: FixedWidthInteger>(for value: Scalar, as: T.Type) throws(Error) -> T {
        guard let ticks = T(exactly: try coordinate(for: value)) else { throw .outOfRange }
        return ticks
    }


    public func value<T: BinaryInteger>(at ticks: T) throws(Error) -> Scalar {
        let coordinate = Scalar(ticks)
        let value = coordinate * quantum
        guard coordinate.isFinite, value.isFinite else { throw .outOfRange }
        return value
    }
}

extension Quantizer: Swift.Sendable where Scalar: Swift.Sendable {}

extension Quantizer: Swift.Equatable {}
