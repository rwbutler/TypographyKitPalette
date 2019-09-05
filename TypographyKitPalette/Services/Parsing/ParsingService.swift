//
//  ParsingService.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

import AppKit

protocol ParsingService {
    func parse(_ data: Data) -> ParsingServiceResult?
}

private enum CodingKeys {
    static let colorsEntry = "typography-colors"
    static let minimumPointSize = "minimum-point-size"
    static let maximumPointSize = "maximum-point-size"
    static let pointStepMultiplier = "point-step-multiplier"
    static let pointStepSize = "point-step-size"
    static let scalingMode = "scaling-mode"
    static let stylesEntry = "ui-font-text-styles"
    static let umbrellaEntry = "typography-kit"
}

typealias ColorEntries = [String: Any]

extension ParsingService {
    func parse(_ configEntries: [String: Any]) -> ParsingServiceResult? {
        let colorEntries = configEntries[CodingKeys.colorsEntry] as? ColorEntries ?? [:]
        var colorParser = ColorParser(colors: colorEntries)
        let typographyColors = colorParser.parseColors()
    
        return typographyColors
    }
    
}
