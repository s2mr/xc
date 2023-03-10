// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "xc",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "xc", targets: ["Command"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0")
    ],
    targets: [
        .executableTarget(
            name: "Command",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "CommandTests",
            dependencies: ["Command"]),
    ]
)
