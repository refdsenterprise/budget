// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserInterface",
    defaultLocalization: "pt",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .macCatalyst(.v15),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "UserInterface",
            targets: ["UserInterface"]),
    ],
    dependencies: [
        .package(path: "Domain"),
        .package(path: "Presentation"),
        .package(path: "Resource"),
        .package(url: "https://github.com/refdsenterprise/refds-core.git", branch: "main"),
        .package(url: "https://github.com/refdsenterprise/refds-design-system.git", branch: "develop")
    ],
    targets: [
        .target(
            name: "UserInterface",
            dependencies: [
                "Domain",
                "Presentation",
                "Resource",
                .product(name: "RefdsCore", package: "refds-core"),
                .product(name: "RefdsUI", package: "refds-design-system")
            ]),
    ]
)
