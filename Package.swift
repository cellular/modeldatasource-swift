// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "ModelDataSource",
    platforms: [
        .iOS(.v12), .tvOS(.v12)
    ],
    products: [
        .library(name: "ModelDataSource", targets: ["ModelDataSource"]),
    ],
    targets: [
        .target(name: "ModelDataSource", path: "Source/Core"),
        .testTarget(name: "ModelDataSourceTests", dependencies: ["ModelDataSource"], path: "Tests")
    ]
)
