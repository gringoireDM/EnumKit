// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "EnumKit",
    platforms: [
      .macOS(.v10_10), .iOS(.v10), .tvOS(.v10), .watchOS(.v4)
    ],
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
