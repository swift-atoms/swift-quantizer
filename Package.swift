// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-quantizer",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [
        .library(
            name: "Quantizer",
            targets: ["Quantizer"]
        ),
        .library(
            name: "Quantizer Foundation Integration",
            targets: ["Quantizer Foundation Integration"]
        ),
        .library(
            name: "Quantizer Test Support",
            targets: ["Quantizer Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-rounding.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Quantizer",
            dependencies: [.product(
                name: "Rounding",
                package: "swift-rounding"
            )],
            path: "Sources/Quantizer"
        ),
        .target(
            name: "Quantizer Foundation Integration",
            dependencies: ["Quantizer"],
            path: "Sources/Quantizer Foundation Integration"
        ),
        .target(
            name: "Quantizer Test Support",
            dependencies: ["Quantizer"],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Quantizer Tests",
            dependencies: [
                "Quantizer",
                "Quantizer Foundation Integration",
                "Quantizer Test Support"
            ],
            path: "Tests/Quantizer Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
