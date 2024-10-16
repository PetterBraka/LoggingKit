// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoggingKit",
    platforms: [
        .macOS(.v11),
        .iOS(.v15),
        .watchOS(.v8),
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
