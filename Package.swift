// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "EnumKit",
    products: [
        .library(
            name: "EnumKit",
            targets: ["EnumKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EnumKit",
            dependencies: []),
        .testTarget(
            name: "EnumKitTests",
            dependencies: ["EnumKit"]),
    ]
)
