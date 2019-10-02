//
//  CatalogColor.swift
//  palette
//
//  Created by Roger Smith2 on 22/08/2019.
//
import Foundation

struct AssetCatalog {
    struct Info: Codable {
        let version: Int = 1
        let author: String = "xcode"
    }
    
    struct CatalogColor: Codable {
        let info: Info = Info()
        let colors: [ColorVariant]
    }
    
    struct ColorVariant: Codable {
        let idiom: String = "universal"
        let appearances: [Appearance]
        let color: SRGBColor
    }

    struct Appearance: Codable {
        let appearance: String = "luminosity"
        let value: String
    }
    
    struct SRGBColor: Codable {
        enum Key: String, CodingKey {
            case colorSpace = "color-space"
            case components
        }
        
        let colorSpace: String = "srgb"
        let components: ColorComponents
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: Key.self)
            try container.encode(colorSpace, forKey: .colorSpace)
            try container.encode(components, forKey: .components)
        }
    }
    
    struct ColorComponents: Codable {
        let red: String
        let green: String
        let blue: String
        let alpha: String
        
        init(red: Float, alpha: Float, green: Float, blue: Float) {
            self.red = String(red)
            self.alpha = String(alpha)
            self.green = String(green)
            self.blue = String(blue)
        }
        
        init(red: CGFloat, alpha: CGFloat, green: CGFloat, blue: CGFloat) {
            self.red = String(Float(red))
            self.alpha = String(Float(alpha))
            self.green = String(Float(green))
            self.blue = String(Float(blue))
        }
        
        init(hexString: String) {
             let unparsed = hexString.hasPrefix("#")
                       ? String(hexString[hexString.index(after: hexString.startIndex)...])
                       : hexString
                   
            let redComponentIdx = unparsed.startIndex,
            greenComponentIdx = unparsed.index(unparsed.startIndex, offsetBy: 2),
            blueComponentIdx = unparsed.index(unparsed.startIndex, offsetBy: 4)
            
            let redComponent = unparsed[redComponentIdx..<greenComponentIdx],
            greenComponent = unparsed[greenComponentIdx..<blueComponentIdx],
            blueComponent = unparsed[blueComponentIdx..<unparsed.endIndex]
            
            self.red = "0x" + String(redComponent).uppercased()
            self.green = "0x" + String(greenComponent).uppercased()
            self.blue = "0x" + String(blueComponent).uppercased()
            self.alpha = "1.0"
        }
    }
}
