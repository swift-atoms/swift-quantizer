# Quantizer

`Quantizer<Scalar>` maps finite scalar values to a uniform grid. A grid has a finite, strictly positive quantum and an explicit Rounding policy; the default selects the nearest level with ties away from zero. Rounding selects a grid coordinate; Quantizer defines the spacing.

The coordinate is computed in the chosen floating-point representation as `value / quantum`, rounded to an integral scalar, and multiplied by the quantum. This is floating-point grid arithmetic, not an exact rational lattice: nonbinary quanta can introduce representation error. There is no implicit Int64 bound. `ticks(for:as:)` explicitly requests fixed-width storage and reports range failure. `value(at:)` converts the coordinate to the scalar representation and can round large integers.

Invalid quanta, nonfinite input, unrepresentable intermediate/output values, and inexact results under exact rounding throw cases of `Quantizer<Scalar>.Error`. Signed zero is preserved. `Quantized` declares a type-level uniform grid; spatial tagging and geometry arithmetic remain consumer responsibilities.

The core depends on Rounding, without Foundation or custom C packages.
