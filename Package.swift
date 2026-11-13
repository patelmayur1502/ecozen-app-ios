// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "EcoZen",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "EcoZen",
            targets: ["EcoZen"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EcoZen",
            dependencies: []
        ),
    ]
)

