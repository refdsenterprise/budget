// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Transaction",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .macCatalyst(.v15),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "Transaction",
            targets: ["Transaction"]),
    ],
    dependencies: [
        .package(path: "Domain"),
        .package(path: "Presentation"),
        .package(path: "UserInterface"),
        .package(url: "https://github.com/refdsenterprise/refds-design-system.git", branch: "develop")
    ],
    targets: [
        .target(
            name: "Transaction",
            dependencies: [
                "Domain",
                "Presentation",
                "UserInterface",
                .product(name: "RefdsUI", package: "refds-design-system")
            ]),
    ]
)
