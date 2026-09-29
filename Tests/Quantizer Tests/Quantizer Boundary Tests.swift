import Quantizer
import Testing

private enum Quarter: Quantized {
    static var quantum: Double { 0.25 }
}

@Suite
struct `Quantizer boundaries` {
    @Test
    func `ticks reach both ends of a narrow integer and no further`() throws {
        let grid = try Quantizer<Double>(quantum: 0.25)
        #expect(try grid.ticks(for: 31.75, as: Int8.self) == 127)
        #expect(try grid.ticks(for: -32, as: Int8.self) == -128)
        #expect(throws: Quantizer<Double>.Error.outOfRange) { try grid.ticks(for: 32, as: Int8.self) }
        #expect(throws: Quantizer<Double>.Error.outOfRange) { try grid.ticks(for: -0.25, as: UInt8.self) }
    }

    @Test
    func `ties round away from zero by default`() throws {
        let grid = try Quantizer<Double>(quantum: 1)
        #expect(try grid(0.5) == 1)
        #expect(try grid(-0.5) == -1)
        #expect(try grid(0.49) == 0)
    }

    @Test
    func `negative ticks map back to negative values`() throws {
        let grid = try Quantizer<Double>(quantum: 0.25)
        #expect(try grid.value(at: -4) == -1)
        #expect(try grid.value(at: 0) == 0)
    }

    @Test
    func `values on the grid are unchanged`() throws {
        let grid = try Quantizer<Double>(quantum: 0.25)
        for value in [-1.0, -0.25, 0, 0.25, 1, 1_000_000] {
            #expect(try grid(value) == value)
        }
    }

    @Test
    func `a quantized type uses its own quantum`() throws {
        #expect(try Quarter.quantize(0.3) == 0.25)
        #expect(Quarter.quantum(as: Float.self) == 0.25)
    }
}
