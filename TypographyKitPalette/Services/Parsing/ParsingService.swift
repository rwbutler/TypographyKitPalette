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

extension ParsingService {

    func parse(_ configEntries: [String: Any]) -> ParsingServiceResult? {
        var typographyColors: [String: NSColor] = [:]
        if let jsonColorEntries = configEntries[CodingKeys.colorsEntry] as? ColorEntries {
            typographyColors = parseColorEntries(jsonColorEntries)
        }
        return typographyColors
    }

}

private extension ParsingService {

    // MARK: - Type definitions
    private typealias ColorEntries = [String: String]

    /// Parses color definitions from the configuration file.
    /// - parameter jsonColorEntries: A dictionary representing color names mapping to
    /// color values as defined in the configuration file.
    /// - returns: A dictionary mapping from the color name to the color value.
    private func parseColorEntries(_ colorEntries: ColorEntries) -> TypographyColors {
        var result: TypographyColors = [:]
        var extendedColors: [(colorKey: String, colorValue: String)] = [] // Keys which are synonyms for other colors.
        for (colorName, colorValue) in colorEntries {
            if let color = parseColorString(colorValue) {
                result[colorName] = color
            } else {
                extendedColors.append((colorName, colorValue))
            }
            for extendedColor in extendedColors {
                let colorValue = extendedColor.colorValue
                if let newColor = parseColorString(colorValue, colorEntries: result) {
                    result[extendedColor.colorKey] = newColor
                }
            }
            // Keep colors which cannot yet be parsed.
            extendedColors = extendedColors.filter { result[$0.colorKey] == nil }
        }
        for extendedColor in extendedColors {
            if let newColor = parseColorString(extendedColor.colorValue, colorEntries: result) {
                result[extendedColor.colorKey] = newColor
            }
        }
        return result
    }

    /// Parses a color represented as a `String`.
    private func parseColorString(_ colorString: String, colorEntries: TypographyColors = [:]) -> NSColor? {
        let shades = ["light", "lighter", "lightest", "dark", "darker", "darkest"]
        for shade in shades where colorString.contains(shade) {
            let withWhitespaces = [" \(shade)", "\(shade) "]
            for withWhitespace in withWhitespaces where colorString.contains(withWhitespace) {
                let colorValue = trimWhitespace(colorString.replacingOccurrences(of: withWhitespace, with: ""))
                if let color = colorEntries[colorValue] {
                    return color.shade(shade)
                }
                return TypographyColor(string: colorValue)?.nsColor.shade(shade)
            }
        }
        if let color = colorEntries[colorString] {
            return color
        }
        return TypographyColor(string: colorString)?.nsColor
    }

    /// Returns the provided the provided `String` with whitespace trimmed.
    /// - parameter string: The `String` to be trimmed.
    /// - returns: The original `String` with whitespace trimmed.
    private func trimWhitespace(_ string: String) -> String {
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}
