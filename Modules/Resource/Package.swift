// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Resource",
    defaultLocalization: "pt",
    platforms: [
        .iOS(.v14),
        .macOS(.v12),
        .macCatalyst(.v15),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "Resource",
            targets: ["Resource"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Resource",
            dependencies: []),
    ]
)
