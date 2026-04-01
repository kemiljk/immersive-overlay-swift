// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ImmersiveOverlay",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "ImmersiveOverlay",
            targets: ["ImmersiveOverlay"]
        ),
    ],
    targets: [
        .target(
            name: "ImmersiveOverlay",
            path: "Sources/ImmersiveOverlay"
        ),
    ]
)
