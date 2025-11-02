// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Viventiva",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Viventiva",
            targets: ["Viventiva"]),
    ],
    dependencies: [
        .package(url: "https://github.com/supabase/supabase-swift", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "Viventiva",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift")
            ]),
        .testTarget(
            name: "ViventivaTests",
            dependencies: ["Viventiva"]),
    ]
)

