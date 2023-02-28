// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Palette",
    platforms: [
        .iOS("13.0"),
        .macOS("10.15")
    ],
    products: [
        .library(name: "TypographyKitPalette", targets: ["TypographyKitPalette"]),
        .executable(name: "Palette", targets: ["Palette"]),
        .plugin(name: "GenerateAssetCatalog", targets: ["AssetCatalogPlugin"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "TypographyKitPalette",
            path: "TypographyKitPalette"
        ),
        .executableTarget(
            name: "Palette",
            dependencies: [
                .target(name: "TypographyKitPalette")
            ],
            path: "code/tools"
        ),
        .plugin(
            name: "AssetCatalogPlugin",
            capability: .command(
                intent: .custom(
                    verb: "generate-asset-catalog",
                    description: "Generate asset catalog containing TypographKit colors."
                )
            ),
            dependencies: [
                .target(name: "TypographyKitPalette")
            ],
            path: "code/plugins/asset-catalog"
        )
    ]
)
