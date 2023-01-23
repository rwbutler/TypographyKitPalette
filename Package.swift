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
    dependencies: [
        .package(url: "https://github.com/rwbutler/LetterCase.git", from: "1.6.1")
    ],
    targets: [
        .target(
            name: "TypographyKitPalette", 
            dependencies: [
                .product(name: "LetterCase", package: "LetterCase")
            ],
            path: "TypographyKitPalette"
        )
    ]
)
