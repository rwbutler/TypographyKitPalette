//
//  TypographyInterfaceStyle.swift
//  palette
//
//  Created by Roger Smith on 02/08/2019.
//

import Foundation

public enum TypographyInterfaceStyle: String {
    case light
    case dark
    
    var assetCatalogAppearanceValue: String {
        return self.rawValue
    }
}
