import Quantizer
import Testing

@Suite struct QuantizerTests {
    @Test func gridPolicyAndExplicitStorage() throws {
        let grid = try Quantizer<Double>(quantum: 0.25)
        #expect(try grid(0.375) == 0.5)
        #expect(try grid(-0.375) == -0.5)
        #expect(try grid(-0.0).sign == .minus)
        #expect(try grid.ticks(for: 1, as: Int8.self) == 4)
        #expect(try grid.value(at: 4) == 1)
        #expect(try Quantizer<Double>(quantum: 1, rounding: .even)(2.5) == 2)
    }

    @Test func noImplicitInt64Boundary() throws {
        let grid = try Quantizer<Double>(quantum: 1)
        #expect(try grid(0x1p80) == 0x1p80)
        #expect(throws: Quantizer::Failure.outOfRange) { try grid.ticks(for: 0x1p80, as: Int64.self) }
        #expect(try grid.ticks(for: 0x1p80, as: UInt128.self) == UInt128(1) << 80)
    }

    @Test func invalidInputsAndRepresentabilityFailures() throws {
        for quantum in [0.0, -1.0, .nan, .infinity] {
            #expect(throws: Quantizer::Failure.invalidQuantum) { try Quantizer(quantum: quantum) }
        }
        let grid = try Quantizer<Double>(quantum: 0.25, rounding: .exact)
        #expect(throws: Quantizer::Failure.inexact) { try grid(0.3) }
        #expect(throws: Quantizer::Failure.nonfinite) { try grid(.nan) }
        #expect(throws: Quantizer::Failure.outOfRange) { try grid(.greatestFiniteMagnitude) }
        let coarse = try Quantizer<Double>(quantum: .greatestFiniteMagnitude, rounding: .up)
        #expect(throws: Quantizer::Failure.outOfRange) { try coarse.value(at: 2) }
    }
}
