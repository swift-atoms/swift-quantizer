import Quantizer
import Testing

@Suite struct `Quantizer maps values onto a uniform grid` {
    @Test func `Grid rounding follows its policy and storage is explicit`() throws {
        let grid = try Quantizer<Double>(quantum: 0.25)
        #expect(try grid(0.375) == 0.5)
        #expect(try grid(-0.375) == -0.5)
        #expect(try grid(-0.0).sign == .minus)
        #expect(try grid.ticks(for: 1, as: Int8.self) == 4)
        #expect(try grid.value(at: 4) == 1)
        #expect(try Quantizer<Double>(quantum: 1, rounding: .even)(2.5) == 2)
    }

    @Test func `Quantization has no implicit Int64 boundary`() throws {
        let grid = try Quantizer<Double>(quantum: 1)
        #expect(try grid(0x1p80) == 0x1p80)
        #expect(throws: Quantizer<Double>.Error.outOfRange) { try grid.ticks(for: 0x1p80, as: Int64.self) }
        #expect(try grid.ticks(for: 0x1p80, as: UInt128.self) == UInt128(1) << 80)
    }

    @Test func `Invalid inputs and unrepresentable results report errors`() throws {
        for quantum in [0.0, -1.0, .nan, .infinity] {
            #expect(throws: Quantizer<Double>.Error.invalidQuantum) { try Quantizer(quantum: quantum) }
        }
        let grid = try Quantizer<Double>(quantum: 0.25, rounding: .exact)
        #expect(throws: Quantizer<Double>.Error.inexact) { try grid(0.3) }
        #expect(throws: Quantizer<Double>.Error.nonfinite) { try grid(.nan) }
        #expect(throws: Quantizer<Double>.Error.outOfRange) { try grid(.greatestFiniteMagnitude) }
        let coarse = try Quantizer<Double>(quantum: .greatestFiniteMagnitude, rounding: .up)
        #expect(throws: Quantizer<Double>.Error.outOfRange) { try coarse.value(at: 2) }
    }
}
