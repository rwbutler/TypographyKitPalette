//
//  AssetCatalogExportingService.swift
//  TypographyKit
//
//  Created by Roger Smith on 21/08/2019.
//

import Foundation
import AppKit

struct AssetCatalogExportingService: ExportingService {
    var baseURL: URL
    
    init(baseURL: URL?) {
        self.baseURL = baseURL ?? URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    }
    
    func export(colors: TypographyColors, colorListName: String) {
        let assetCatalogURL = baseURL
            .appendingPathComponent("\(colorListName).xcassets")
        
        //Save the asset catalog contents file
        let outputURL = assetCatalogURL.appendingPathComponent("Contents.json")
        let info = AssetCatalog.Info()
        writeToFile(info, outputURL)
        
        exportColors(colors, catalogURL: assetCatalogURL)
        
    }
}

private extension AssetCatalogExportingService {
    func exportColors(_ colors: TypographyColors, catalogURL: URL) {
        let sortedColors = colors.sorted { $0.key < $1.key }
        sortedColors.forEach { (arg) in
            let (colorName, typographyColor) = arg
            let outputURL = catalogURL
                .appendingPathComponent("\(colorName).colorset")
                .appendingPathComponent("Contents.json")
            
            var colorVariants: [AssetCatalog.ColorVariant] = []
            
            switch typographyColor {
            case .dynamicColor(_, let dynamicColors):
                TypographyInterfaceStyle.allCases.forEach { interfaceStyle in
                    guard let colorForInterfaceStyle = dynamicColors[interfaceStyle] else {
                        return
                    }
                    let appearance = AssetCatalog.Appearance(value: interfaceStyle.assetCatalogAppearanceValue)
                    let variant = colorVariant(for: colorForInterfaceStyle, appearance: appearance)
                    colorVariants.append(variant)
                }
            default:
                let variant = colorVariant(for: typographyColor)
                colorVariants.append(variant)
            }
            let colorsJSON = AssetCatalog.CatalogColor(colors: colorVariants)
            writeToFile(colorsJSON, outputURL)
        }
    }
    
    func writeToFile<EncodableType: Encodable>(_ codable: EncodableType, _ outputURL: URL) {
        do {
            let directoryURL = outputURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(codable)
            try data.write(to: outputURL)
            
        } catch let error {
            print(error)
        }
    }
    
    func colorVariant(for color: TypographyColor, appearance: AssetCatalog.Appearance? = nil)
    -> AssetCatalog.ColorVariant {
        let colorComponents: AssetCatalog.ColorComponents
        switch color {
        case .dynamicColor(_, let colors):
            if let darkColor = colors[.dark] {
                return colorVariant(for: darkColor, appearance: appearance)
            }
            if let lightColor = colors[.light] {
                return colorVariant(for: lightColor, appearance: appearance)
            }
            fatalError()
        case .hexWithoutAlpha(let hexString), .hexWithAlpha(let hexString):
            colorComponents = AssetCatalog.ColorComponents(hexString: hexString)
        case .rgb(let red, let green, let blue):
            colorComponents = AssetCatalog.ColorComponents(red: red, alpha: 1, green: green, blue: blue)
        case .rgba(let red, let green, let blue, let alpha):
            colorComponents = AssetCatalog.ColorComponents(red: red, alpha: alpha, green: green, blue: blue)
        default:
            let colorCs = color.nsColor.colorComponents(scalingFactor: 1)
            colorComponents = AssetCatalog.ColorComponents(
                red: colorCs.red,
                alpha: colorCs.alpha,
                green: colorCs.green,
                blue: colorCs.blue
            )
        }
        let appearances = [appearance].compactMap { $0 }
        let colorInfo = AssetCatalog.SRGBColor(components: colorComponents)
        let color = AssetCatalog.ColorVariant(appearances: appearances, color: colorInfo)
        
        return color
    }
}
