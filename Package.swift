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
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Box",
            dependencies: [],
            path: "Swift/Sources/Surrow"),
        .target(
            name: "Circle",
            dependencies: [],
            path: "Swift/Sources/Surrow"),
        .target(
            name: "Collidable",
            dependencies: [],
            path: "Swift/Sources/Surrow"),
        .target(
            name: "Line",
            dependencies: [],
            path: "Swift/Sources/Surrow"),
        .target(
            name: "Point",
            dependencies: [],
            path: "Swift/Sources/Surrow"),
        .target(
            name: "Polygon",
            dependencies: [],
            path: "Swift/Sources/Surrow"),
        .target(
            name: "Segment",
            dependencies: [],
            path: "Swift/Sources/Surrow"),
        .target(
            name: "Size",
            dependencies: [],
            path: "Swift/Sources/Surrow"),
        .target(
            name: "Vector",
            dependencies: [],
            path: "Swift/Sources/Surrow")
        
    ]
)
