// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoggingKit",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .watchOS(.v11),
    ],
    products: [
        .library(
            name: "LoggingKit",
            targets: ["LoggingKit"]
        ),
    ],
    targets: [
        .target(
            name: "LoggingKit",
            path: "Sources"
        ),
        .testTarget(
            name: "LoggerTests",
            dependencies: ["LoggingKit"],
            path: "Tests"
        ),
    ]
)
