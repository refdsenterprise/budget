// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .macCatalyst(.v15),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]),
    ],
    dependencies: [
        .package(path: "Domain"),
        .package(path: "Presentation"),
        .package(path: "UserInterface")
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                "Domain",
                "Presentation",
                "UserInterface"
            ]),
    ]
)
