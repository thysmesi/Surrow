// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Surrow",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Surrow",
            targets: ["Surrow"]),
    ],
    dependencies: [
//        .package(name: "LibTessSwift", url: "https://github.com/LuizZak/LibTessSwift.git", branch: "master")
    ],
    targets: [
        .target(
            name: "Surrow",
            dependencies: [],
            path: "Swift/Sources/Surrow")
    ]
)
