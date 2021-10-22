// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Surrow",
    products: [
        .library(
            name: "Surrow",
            targets: ["Surrow"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Surrow",
            dependencies: []),
        .testTarget(
            name: "SurrowTests",
            dependencies: ["Surrow"]),
    ]
)
