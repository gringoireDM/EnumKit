// swift-tools-version:5.0
import PackageDescription

var package = Package(
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

//#if !canImport(Combine)
package.dependencies = [
    .package(url: "https://github.com/broadwaylamb/OpenCombine.git", from: "0.3.0")
]

if let enumKit = package.targets.first(where: { $0.name == "EnumKit" }) {
    enumKit.dependencies = [ "OpenCombine" ]
}
//#endif
