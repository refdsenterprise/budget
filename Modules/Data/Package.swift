// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .macCatalyst(.v15),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]),
    ],
    dependencies: [
        .package(path: "Domain"),
        .package(path: "Resource"),
        .package(url: "https://github.com/refdsenterprise/refds-core.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                "Domain",
                "Resource",
                .product(name: "RefdsCore", package: "refds-core")
            ]),
    ]
)
