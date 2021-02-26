// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "Demure",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "DemureAPI", targets: ["DemureAPI"]),
        .executable(name: "demure", targets: ["DemureRun"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.13.0")
    ],
    targets: [
        .target(name: "DemureAPI"),
        .testTarget(name: "DemureAPITests", dependencies: ["DemureAPI"]),
        .target(name: "DemureApp", dependencies: [
            .target(name: "DemureAPI"),
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Stencil", package: "Stencil")
        ]),
        .testTarget(name: "DemureAppTests", dependencies: [
            .target(name: "DemureApp"),
            .product(name: "XCTVapor", package: "vapor"),
        ]),
        .target(name: "DemureRun", dependencies: ["DemureApp"]),
    ]
)
