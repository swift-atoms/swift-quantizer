
public protocol Quantized {
    associatedtype Scalar: BinaryFloatingPoint
    static var quantum: Scalar { get }
}

extension Quantized {
    public static func quantize(_ value: Scalar) throws(Quantizer<Scalar>.Error) -> Scalar {
        try Quantizer(quantum: quantum)(value)
    }

    public static func quantum<T: BinaryFloatingPoint>(as type: T.Type) -> T { T(quantum) }
}
