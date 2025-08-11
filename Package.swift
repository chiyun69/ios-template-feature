// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "template-feature",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "template-feature",
            targets: ["template-feature"]
        )
    ],
    dependencies: [
        // Add external dependencies if needed
        // Example: .package(url: "https://github.com/example/dependency", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "template-feature",
            dependencies: [],
            path: "template-feature",
            exclude: [
                "template_feature.docc",
                "Resources/README.md"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "template-featureTests",
            dependencies: ["template-feature"],
            path: "template-featureTests",
            exclude: [
                "Info.plist"
            ]
        )
    ]
)