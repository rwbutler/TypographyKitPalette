// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Palette",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(name: "Palette", targets: ["TypographyKitPalette"])
    ],
    targets: [
        .target(name: "TypographyKitPalette", path: "TypographyKitPalette")
    ]
)
