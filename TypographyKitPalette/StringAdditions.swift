//
//  StringAdditions.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/16/17.
//
//

import Foundation

public extension String {
    func letterCase(_ letterCase: LetterCase, preserveSuffix: Bool = false) -> String {
        switch letterCase {
        case .capitalized:
            return self.capitalized()
        case .kebab:
            return self.kebabCased(preserveSuffix: preserveSuffix)
        case .lower:
            return self.lowercased()
        case .lowerCamel:
            return self.lowerCamelCased(preserveSuffix: preserveSuffix)
        case .macro:
            return self.macroCased()
        case .snake:
            return self.snakeCased()
        case .upper:
            return self.uppercased()
        case .upperCamel:
            return self.upperCamelCased(preserveSuffix: preserveSuffix)
        default:
            return self
        }
    }

    func capitalized() -> String {
        let dashesReplaced = self.replacingOccurrences(of: "-", with: " ")
        var isPrevCharLowercase = true
        var buffer: String = ""
        for character in dashesReplaced {
            if !(character.isLowercaseLatin() || character.isSpace()) && isPrevCharLowercase {
                buffer = buffer.appending(" ")
            }
            isPrevCharLowercase = character.isLowercaseLatin()
            buffer = buffer.appending(String(character))
        }
        return buffer.capitalized
    }

    func kebabCased(preserveSuffix: Bool = false) -> String {
        return self.capitalizeSubSequences(shouldCapitalizeFirst: false,
                                           conjunction: "-",
                                           preserveSuffix: preserveSuffix)
    }

    func lowerCamelCased(preserveSuffix: Bool = false) -> String {
        let upperCamelCased = self.upperCamelCased(preserveSuffix: preserveSuffix)
        if let firstChar = self.first {
            return String(firstChar).lowercased() + String(upperCamelCased.dropFirst())
        }
        return upperCamelCased
    }

    func macroCased() -> String {
        return self.capitalizeSubSequences(shouldCapitalizeFirst: true, conjunction: "_").uppercased()
    }

    func snakeCased() -> String {
        return self.capitalizeSubSequences(shouldCapitalizeFirst: false)
    }

    func upperCamelCased(preserveSuffix: Bool = false) -> String {
        return self.capitalizeSubSequences(shouldCapitalizeFirst: true, preserveSuffix: preserveSuffix)
    }

    private func capitalizeSequence(shouldCapitalizeFirst: Bool, conjunction: String, preserveSuffix: Bool) -> String {
        guard let firstChar = self.first else { return self }
        let firstCharacter = shouldCapitalizeFirst ? firstChar.uppercased() : firstChar.lowercased()
        let newPrefix = String(firstCharacter)
        let newSuffix = preserveSuffix ? suffix() : lowercasedSuffix()
        return newPrefix + newSuffix + conjunction
    }

    private func capitalizeSubSequences(shouldCapitalizeFirst: Bool,
                                        conjunction: String = "",
                                        preserveSuffix: Bool = false) -> String {
        var result = ""
        for subSequence in self.split(separator: " ") {
            let subString = String(subSequence)
            result += subString.capitalizeSequence(shouldCapitalizeFirst: shouldCapitalizeFirst,
                                                   conjunction: conjunction,
                                                   preserveSuffix: preserveSuffix)
        }
        if !conjunction.isEmpty, !result.isEmpty {
            return String(result.dropLast())
        }
        return result
    }

    private func lowercasedSuffix() -> String {
        return suffix().lowercased()
    }

    private func suffix() -> String {
        return String(self.dropFirst())
    }

}

extension Character {

    private func firstUnicodeCodePoint() -> UInt32? {
        return unicodeScalars.first?.value
    }

    func isLowercaseLatin() -> Bool {
        guard let codePoint = firstUnicodeCodePoint() else { return false }
        let lowercaseLatinCodePoints = UInt32(97)...UInt32(122)
        return lowercaseLatinCodePoints.contains(codePoint)
    }

    func isSpace() -> Bool {
        return (firstUnicodeCodePoint() ?? 0) == 32
    }

    func lowercased() -> Character {
        return String(self).lowercased().first ?? Character("")
    }

    func uppercased() -> Character {
        return String(self).uppercased().first ?? Character("")
    }

}
