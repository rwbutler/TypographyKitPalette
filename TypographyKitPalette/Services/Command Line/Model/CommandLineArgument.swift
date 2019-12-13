//
//  CommandLineArgument.swift
//  TypographyKit
//
//  Created by Ross Butler on 6/1/18.
//

import Foundation

enum CommandLineArgument: String {
    case none
    case colorListNameShorthand = "-n"
    case colorListName = "--color-list"
    case configURLShorthand = "-c"
    case configURL = "--config-url"
    case assetCatalogURL = "--asset-catalog-url"
    case assetCatalogURLShorthand = "-a"
    case export = "--export"
    case exportShorthand = "-e"
}

enum Export: String {
    case palette
    case assetCatalog
}
