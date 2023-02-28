//
//  PalettePlugin.swift
//  TypographyKit Palette
//
//  Created by Ross Butler on 28/02/2023.
//

import Foundation
import PackagePlugin

enum ExportOption: String {
    case assetCatalog
    case palette
}

enum ExportModel {
    case assetCatalog(configURL: URL, name: String, assetCatalogURL: URL)
    case colorList(configURL: URL, name: String)
}

@main
struct PalettePlugin: CommandPlugin {
    func export(tool: PluginContext.Tool, model: ExportModel) throws {
        let paletteExec = URL(fileURLWithPath: tool.path.string)
        
        var arguments: [String] = ["export"]
        switch model {
        case let .colorList(configURL, name):
            arguments.append(contentsOf: ["--config-url", configURL.absoluteString])
            arguments.append(contentsOf: ["--color-list", name])
        case let .assetCatalog(configURL, name, assetCatalogURL):
            arguments.append(contentsOf: ["--asset-catalog-url", assetCatalogURL.absoluteString])
            arguments.append(contentsOf: ["--config-url", configURL.absoluteString])
            arguments.append(contentsOf: ["--color-list", name])
        }
        let process = try Process.run(paletteExec, arguments: arguments)
        process.waitUntilExit()
        
        if process.terminationReason == .exit && process.terminationStatus == 0 {
            switch model {
            case .assetCatalog:
                print("Exported asset catalog.")
            case .colorList:
                print("Exported color palette.")
            }
        } else {
            let problem = "\(process.terminationReason):\(process.terminationStatus)"
            Diagnostics.error("palette invocation failed: \(problem)")
        }
    }
    
    func performCommand(context: PluginContext, arguments: [String]) throws {
        let palette = try context.tool(named: "palette")
        var argExtractor = ArgumentExtractor(arguments)
        let exportRawValue = argExtractor.extractOption(named: "export").first ?? ""
        let exportOption = ExportOption(rawValue: exportRawValue) ?? .assetCatalog
        let configURLStr = argExtractor.extractOption(named: "config-url")
        
        guard let configURL = URL(string: configURLStr.first ?? "") else {
            Diagnostics.error("palette invocation failed: TypographyKit configuration URL not specified.")
            return
        }
        switch exportOption {
        case .assetCatalog:
            guard let assetCatalogName = argExtractor.extractOption(named: "color-list").first else {
                Diagnostics.error("palette invocation failed: Asset catalog name not specified.")
                return
            }
            guard let assetCatalogURLStr = argExtractor.extractOption(named: "asset-catalog-url").first,
                  let assetCatalogURL = URL(string: assetCatalogURLStr) else {
                Diagnostics.error("palette invocation failed: Asset catalog URL not specified.")
                return
            }
            let exportModel = ExportModel.assetCatalog(configURL: configURL, name: assetCatalogName, assetCatalogURL: assetCatalogURL)
            try export(tool: palette, model: exportModel)
        case .palette:
            guard let colorListName = argExtractor.extractOption(named: "color-list").first else {
                Diagnostics.error("palette invocation failed: Color palette name not specified.")
                return
            }
            let exportModel = ExportModel.colorList(configURL: configURL, name: colorListName)
            try export(tool: palette, model: exportModel)
        }
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension PalettePlugin: XcodeCommandPlugin {
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        
    }
}
#endif
