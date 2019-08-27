// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "ModelDataSource",
    platforms: [
        .iOS(.v11), .tvOS(.v11)
    ],
    products: [
        .library(name: "ModelDataSource", targets: ["ModelDataSource"])
    ],
    targets: [
        .target(name: "ModelDataSource"),
        .testTarget(name: "ModelDataSourceTests", dependencies: ["ModelDataSource"])
    ]
)
