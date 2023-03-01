//
//  PalettePlugin.swift
//  TypographyKit Palette
//
//  Created by Ross Butler on 28/02/2023.
//

import Foundation
import PackagePlugin


#if swift(>=5.6)
protocol PluginToolProviding {
    func tool(named name: String) throws -> PackagePlugin.PluginContext.Tool
}

extension PluginContext: PluginToolProviding {}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension XcodePluginContext: PluginToolProviding {}
#endif
#endif

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
        
        var arguments: [String] = []
        switch model {
        case let .colorList(configURL, name):
            arguments.append(contentsOf: ["--export", "palette"])
            arguments.append(contentsOf: ["--config-url", configURL.absoluteString])
            arguments.append(contentsOf: ["--color-list", name])
        case let .assetCatalog(configURL, name, assetCatalogURL):
            arguments.append(contentsOf: ["--export", "assetCatalog"])
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
        if arguments.contains("--verbose") {
            print("Command plugin execution with arguments \(arguments.description) for Swift package \(context.package.displayName). All target information: \(context.package.targets.description)")
        }

        var targetsToProcess: [Target] = context.package.targets

        var argExtractor = ArgumentExtractor(arguments)
        let selectedTargets = argExtractor.extractOption(named: "target")

        if selectedTargets.isEmpty == false {
            targetsToProcess = context.package.targets.filter { selectedTargets.contains($0.name) }.map { $0 }
        }

        for target in targetsToProcess {
            guard let target = target as? SourceModuleTarget else { continue }

            try perform(in: target.directory, context: context, arguments: argExtractor.remainingArguments)
        }
    }

    func perform(in directory: PackagePlugin.Path, context: PluginToolProviding, arguments: [String]) throws {
        let palette = try context.tool(named: "Palette")
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
        var argExtractor = ArgumentExtractor(arguments)
        _ = argExtractor.extractOption(named: "target")


        let argumentsWithConfig = arguments + [
            "--asset-catalog-url", context.xcodeProject.directory.string,
            "--color-list", "TypographyKit",
            "--config-url", context.xcodeProject.directory.appending(["typography-kit.json"]).string
        ]

        try perform(in: context.xcodeProject.directory, context: context, arguments: argumentsWithConfig)
    }
}
#endif
