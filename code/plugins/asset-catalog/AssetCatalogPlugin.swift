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

private extension Command {
    static func swiftgen(using configuration: Path, context: PluginContext, target: Target) throws -> Command {
        let assetCatalogPath = context.package.directory//.appending(["TypographyKit.xcassets"])
        return .prebuildCommand(
            displayName: "TypographyKit Palette BuildTool Plugin",
            executable: try context.tool(named: "Palette").path,
            arguments: [
                "--asset-catalog-url", assetCatalogPath.string,
                "--color-list", "TypographyKit",
                "--configuration-url", configuration.string
            ],
            environment: [
                "PROJECT_DIR": context.package.directory,
                "TARGET_NAME": target.name,
                "PRODUCT_MODULE_NAME": target.moduleName,
                "DERIVED_SOURCES_DIR": context.pluginWorkDirectory
            ],
            outputFilesDirectory: context.pluginWorkDirectory
        )
    }
#if canImport(XcodeProjectPlugin)
    static func buildCommand(using configuration: Path, context: XcodePluginContext, target: XcodeTarget) throws -> Command {
        let assetCatalogPath = context.xcodeProject.directory
        let path = try context.tool(named: "Palette").path
        fatalError(path.string)
        FileManager.default.fileExists(atPath: path.string)
        return .buildCommand(
            displayName: "TypographyKit Palette BuildTool Plugin",
            executable: try context.tool(named: "Palette").path,
            arguments: [
                "--asset-catalog-url", assetCatalogPath.string,
                "--color-list", "TypographyKit",
                "--configuration-url", configuration.string
            ],
            environment: [
                "PROJECT_DIR": context.xcodeProject.directory,
                "TARGET_NAME": target.displayName,
                "DERIVED_SOURCES_DIR": context.pluginWorkDirectory
            ]
            //outputFilesDirectory: context.xcodeProject.directory
        )
    }
#endif
}

private extension PaletteBuildToolPlugin {
    /// Validate the given list of configurations
    func validate(configurations: [Path], target: Target) -> Bool {
        guard !configurations.isEmpty else {
            Diagnostics.error("""
      No SwiftGen configurations found for target \(target.name). If you would like to generate sources for this \
      target include a `swiftgen.yml` in the target's source directory, or include a shared `swiftgen.yml` at the \
      package's root.
      """)
            return false
        }
        
        return true
    }
    
#if canImport(XcodeProjectPlugin)
    func validate(configurations: [Path], target: XcodeTarget) -> Bool {
        guard !configurations.isEmpty else {
            Diagnostics.error("""
        No SwiftGen configurations found for target \(target.displayName). If you would like to generate sources for this \
        target include a `swiftgen.yml` in the target's source directory, or include a shared `swiftgen.yml` at the \
        package's root.
        """)
            return false
        }
        
        return true
    }
#endif
}

@main
struct PaletteBuildToolPlugin: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        let fileManager = FileManager.default
        
        // Possible paths where there may be a config file (root of package, target dir.)
        let configurations: [Path] = [context.package.directory, target.directory]
            .map { $0.appending("TypographyKit.json") }
            .filter { fileManager.fileExists(atPath: $0.string) }
        
        // Validate paths list
        guard validate(configurations: configurations, target: target) else {
            return []
        }
        
        // Clear the SwiftGen plugin's directory (in case of dangling files)
        fileManager.forceClean(directory: context.pluginWorkDirectory)
        
        return try configurations.map { configuration in
            try .swiftgen(using: configuration, context: context, target: target)
        }
    }
    
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
    /*
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
     }*/
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

/*extension PalettePlugin: XcodeCommandPlugin {
 func performCommand(context: XcodePluginContext, arguments: [String]) throws {
 
 }
 }*/

extension PaletteBuildToolPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext, target: XcodeProjectPlugin.XcodeTarget) throws -> [PackagePlugin.Command] {
        let fileManager = FileManager.default
        
        // Possible paths where there may be a config file (root of package, target dir.)
        let configurations: [Path] = [context.xcodeProject.directory]
            .map { $0.appending("typography-kit.json") }
            .filter { fileManager.fileExists(atPath: $0.string) }
        
        // Validate paths list
        /*guard validate(configurations: configurations, target: target) else {
            return []
        }*/
        
        // Clear the SwiftGen plugin's directory (in case of dangling files)
        fileManager.forceClean(directory: context.pluginWorkDirectory)
        
        return try configurations.map { configuration in
            try .buildCommand(using: configuration, context: context, target: target)
        }
        
        
    }
}
#endif

private extension FileManager {
    /// Re-create the given directory
    func forceClean(directory: Path) {
        try? removeItem(atPath: directory.string)
        try? createDirectory(atPath: directory.string, withIntermediateDirectories: false)
    }
}

extension Target {
    /// Try to access the underlying `moduleName` property
    /// Falls back to target's name
    var moduleName: String {
        switch self {
        case let target as SourceModuleTarget:
            return target.moduleName
        default:
            return ""
        }
    }
}
