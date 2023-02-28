//
//  CommandLineProcessor.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/29/18.
//

import Foundation
import AppKit

public struct CommandLineProcessor {
    
    var colorListName: String?
    var configURL: URL?
    var assetCatalogURL: URL?
    var export: [Export] = []
    
    var currentlyPopulating: CommandLineArgument = .none
    
    public init(colorListName: String? = nil, configURL: URL? = nil, assetCatalogURL: URL? = nil) {
        self.colorListName = colorListName
        self.configURL = configURL
        self.assetCatalogURL = assetCatalogURL
    }
    
    public mutating func main() {
        for index in 1 ..< CommandLine.arguments.count {
            processArgument(CommandLine.arguments[index])
        }
        guard let configurationURL = configURL, let colorList = colorListName else {
            printUsage()
            return
        }
        processArguments(configURL: configurationURL, colorListName: colorList)
    }
    
    private func isHTTPURL(urlString: String) -> Bool {
        return urlString.lowercased().starts(with: "https") ||
            urlString.lowercased().starts(with: "http")
    }
    
    private func printUsage() {
        print("Must specify --color-list and either --config-url or --asset-catalog-url arguments")
    }
    
    private mutating func processArgument(_ argumentString: String) {
        if let argument = CommandLineArgument(rawValue: argumentString) {
            currentlyPopulating = argument
            
            if [.export, .exportShorthand].contains(argument) {
                export = []
            }
            return
        }
        
        switch currentlyPopulating {
        case .configURL, .configURLShorthand:
            configURL = url(urlString: argumentString)
        case .colorListName, .colorListNameShorthand:
            colorListName = argumentString
        case .assetCatalogURL, .assetCatalogURLShorthand:
            assetCatalogURL = url(urlString: argumentString)
        case .export, .exportShorthand:
            if let exportType = Export(rawValue: argumentString) {
                export.append(exportType)
            }
        case .none:
            break
        }
    }
    
    private func processArguments(configURL: URL, colorListName: String) {
        TypographyKit.configurationURL = configURL
        TypographyKit.refresh()
        let colors = TypographyKit.colors
        if export.contains(.assetCatalog) {
            AssetCatalogExportingService(baseURL: assetCatalogURL).export(colors: colors, colorListName: colorListName)
        } else if export.contains(.palette) {
            ColorPaletteExportingService().export(colors: colors, colorListName: colorListName)
        } else {
            ColorPaletteExportingService().export(colors: colors, colorListName: colorListName)
        }
        exit(0)
    }
    
    private func url(urlString: String) -> URL? {
        if isHTTPURL(urlString: urlString) {
            return URL(string: urlString)
        } else {
            return URL(fileURLWithPath: urlString).standardizedFileURL
        }
    }
    
}
