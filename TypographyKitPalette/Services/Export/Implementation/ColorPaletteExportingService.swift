//
//  ColorPaletteExportingService.swift
//  palette
//
//  Created by Roger Smith on 05/09/2019.
//
import AppKit

struct ColorPaletteExportingService: ExportingService {
    func export(colors: TypographyColors, colorListName: String) {
        let colorList = NSColorList(name: colorListName)
        let sortedColors = colors.sorted { $0.key < $1.key }
        
       sortedColors.forEach { (arg) in
            let (colorName, color) = arg
            colorList.setColor(color.nsColor, forKey: colorName.capitalized())
        }
        
        var outputURL = FileManager.default.homeDirectoryForCurrentUser
        outputURL = outputURL
            .appendingPathComponent("Library")
            .appendingPathComponent("Colors")
            .appendingPathComponent("\(colorListName).clr")
        try? colorList.write(to: outputURL)
    }
}
