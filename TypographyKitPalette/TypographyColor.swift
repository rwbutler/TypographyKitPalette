//
//  TypographyColor.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/20/17.
//
//

import CoreGraphics
import AppKit

public enum TypographyColor {
    case black
    case darkGray
    case lightGray
    case white
    case gray
    case red
    case green
    case blue
    case cyan
    case yellow
    case magenta
    case orange
    case purple
    case brown
    case clear
    case hex(string: String)
    case named(string: String)
    case rgb(r: Float, g: Float, b: Float)
    case rgba(r: Float, g: Float, b: Float, a: Float)

    static var colorNameMap: [String: NSColor] {
        return ["black": .black,
                "darkGray": .darkGray,
                "lightGray": .lightGray,
                "white": .white,
                "gray": .gray,
                "red": .red,
                "green": .green,
                "blue": .blue,
                "cyan": .cyan,
                "yellow": .yellow,
                "magenta": .magenta,
                "orange": .orange,
                "purple": .purple,
                "brown": .brown,
                "clear": .clear]
    }

    public var cgColor: CGColor {
        return self.NSColor.cgColor
    }

    public var NSColor: NSColor {
        switch self {
        case .black:
            return .black
        case .darkGray:
            return .darkGray
        case .lightGray:
            return .lightGray
        case .white:
            return .white
        case .gray:
            return .gray
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        case .cyan:
            return .cyan
        case .yellow:
            return .yellow
        case .magenta:
            return .magenta
        case .orange:
            return .orange
        case .purple:
            return .purple
        case .brown:
            return .brown
        case .clear:
            return .clear
        case .named(let colorName):
            return TypographyColor.colorNameMap[colorName]! // Previously validated
        case .hex(let hexString):
            return TypographyColor.parseHex(hexString: hexString)!.NSColor // Previously validated
        case .rgb(let r, let g, let b):
            return AppKit.NSColor(calibratedRed: CGFloat(r),
             green: CGFloat(g),
             blue: CGFloat(b),
             alpha: 1.0)
        case .rgba(let r, let g, let b, let a):
            return AppKit.NSColor(calibratedRed: CGFloat(r),
                           green: CGFloat(g),
                           blue: CGFloat(b),
                           alpha: CGFloat(a))
        }
    }

    public init?(string: String) {
        switch string {
        case "#[a-zA-Z0-9]{6}", "[a-zA-Z0-9]{6}":
            if TypographyColor.parseHex(hexString: string) != nil { // Check can be converted to a color
                self = .hex(string: string)
                break
            }
            return nil
        // swiftlint:disable:next line_length
        case "rgb\\(([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]),([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]),([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\)",
             "\\(([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]),([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]),([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\)":
                let rgbValues = type(of: self).rgbValues(from: string)
                if rgbValues.count == 3,
                    let red = Float(rgbValues[0]),
                    let green = Float(rgbValues[1]),
                    let blue = Float(rgbValues[2]) {
                    self = .rgb(r: red / 255.0, g: green / 255.0, b: blue / 255.0)
                    break
                }
                return nil
        default:
            if TypographyColor.colorNameMap[string] != nil { // Validate a color is returned
                self = .named(string: string)
                break
            }
            return nil
        }
    }

    private static func rgbValues(from string: String) -> [String] {
        var colorValues: [String] = []
        do {
            let colorComponentPattern = "[01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]"
            let colorComponentRegEx = try NSRegularExpression(pattern: colorComponentPattern,
                                                              options: .dotMatchesLineSeparators)
            let matches = colorComponentRegEx.matches(in: string,
                                                      options: [],
                                                      range: NSRange(location: 0, length: string.count))
            for match in matches {
                let matchEndIndex = match.range.location + match.range.length
                let startIdx = string.index(string.startIndex, offsetBy: match.range.location)
                let endIdx = string.index(string.startIndex, offsetBy: matchEndIndex)
                let range = startIdx..<endIdx
                colorValues.append(String(string[range]))
            }
        } catch {} // Just return empty array
        return colorValues
    }

    /// Parses a hexadecimal string to a color if possible
    private static func parseHex(hexString: String) -> TypographyColor? {
        guard hexString.count >= 1 else { return nil }
        let startIdx = hexString.index(hexString.startIndex, offsetBy: 1)
        let unparsed = hexString.hasPrefix("#")
            ? String(hexString[startIdx..<hexString.endIndex])
            : hexString
        let r = unparsed[unparsed.startIndex..<unparsed.index(unparsed.index(after: unparsed.startIndex), offsetBy: 1)]
        // swiftlint:disable:next line_length
        let g = unparsed[unparsed.index(unparsed.startIndex, offsetBy: 2)..<unparsed.index(unparsed.startIndex, offsetBy: 4)]
        let b = unparsed[unparsed.index(unparsed.startIndex, offsetBy: 4)..<unparsed.endIndex]

        if let rInt = UInt(r, radix: 16),
            let gInt = UInt(g, radix: 16),
            let bInt = UInt(b, radix: 16) {
            let red = Float(rInt) / 255.0
            let green = Float(gInt) / 255.0
            let blue = Float(bInt) / 255.0
            return .rgb(r: red,
                        g: green,
                        b: blue)
        }
        return nil
    }
}
