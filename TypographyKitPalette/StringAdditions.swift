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
        var isLowercase = true
        var buffer: String = ""
        var index = 0
        for character in dashesReplaced {
            let substringStartIdx = dashesReplaced.index(dashesReplaced.startIndex, offsetBy: index)
            let substringEndIdx = dashesReplaced.index(substringStartIdx, offsetBy: 1)
            if let codePoint = character.unicodeScalars.first?.value, codePoint >= 97, codePoint <= 122 {
                buffer = buffer.appending(dashesReplaced[substringStartIdx..<substringEndIdx])
                isLowercase = true
            } else if let codePoint = character.unicodeScalars.first?.value, codePoint == 32 {
                buffer = buffer.appending(dashesReplaced[substringStartIdx..<substringEndIdx])
                isLowercase = false
            } else {
                if isLowercase {
                    buffer = buffer.appending(" \(dashesReplaced[substringStartIdx..<substringEndIdx])")
                }else {
                    buffer = buffer.appending(dashesReplaced[substringStartIdx..<substringEndIdx])
                }
                isLowercase = false
            }
            index += 1
        }
        return buffer.capitalized
    }
    
    func kebabCased(preserveSuffix: Bool = false) -> String {
        return self.capitalizeSubSequences(capitalizeFirst: false, conjunction: "-", preserveSuffix: preserveSuffix)
    }

    func lowerCamelCased(preserveSuffix: Bool = false) -> String {
        let upperCamelCased = self.upperCamelCased(preserveSuffix: preserveSuffix)
        if let firstChar = self.first {
            return String(firstChar).lowercased() + String(upperCamelCased.dropFirst())
        }
        return upperCamelCased
    }

    func macroCased() -> String {
        return self.capitalizeSubSequences(capitalizeFirst: true, conjunction: "_").uppercased()
    }

    func snakeCased() -> String {
        return self.capitalizeSubSequences(capitalizeFirst: false)
    }

    func upperCamelCased(preserveSuffix: Bool = false) -> String {
        return self.capitalizeSubSequences(capitalizeFirst: true, preserveSuffix: preserveSuffix)
    }

    private func capitalizeSubSequences(capitalizeFirst: Bool,
                                        conjunction: String = "",
                                        preserveSuffix: Bool = false) -> String {
        var result = ""
        for subSequence in self.split(separator: " ") {
            if let firstChar = subSequence.first {
                let prefixWithCase = (capitalizeFirst) ? String(firstChar).uppercased() : String(firstChar).lowercased()
                let suffix = String(subSequence.dropFirst())
                let suffixWithCase = preserveSuffix ? suffix : suffix.lowercased()
                result += prefixWithCase + suffixWithCase + conjunction
            }
        }
        if !conjunction.isEmpty, result.count > 0 {
            return String(result.dropLast())
        }
        return result
    }
}
