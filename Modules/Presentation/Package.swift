// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .macCatalyst(.v15),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "Presentation",
            targets: ["Presentation"]),
    ],
    dependencies: [
        .package(path: "Domain"),
        .package(path: "Data"),
        .package(path: "Resource"),
        .package(path: "UserInterface"),
        .package(url: "https://github.com/refdsenterprise/refds-core.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: [
                "Domain",
                "Data",
                "Resource",
                "UserInterface",
                .product(name: "RefdsCore", package: "refds-core")
            ]),
    ]
)
