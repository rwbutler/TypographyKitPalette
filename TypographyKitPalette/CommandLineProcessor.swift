//
//  CommandLineProcessor.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/29/18.
//

import Foundation
import AppKit

struct CommandLineProcessor {

    func main() {
        var colorListName: String?
        var configURL: URL?
        var populatingColorListName = false
        var populatingConfigURL = false

        func resetPopulationFlags() {
            populatingColorListName = false
            populatingConfigURL = false
        }

        for index in 1 ..< CommandLine.arguments.count {
            let argument = CommandLineArgument(argument: CommandLine.arguments[index])
            switch argument {
            case .configURL, .configURLShorthand:
                resetPopulationFlags()
                populatingConfigURL = true
            case .colorListName, .colorListNameShorthand:
                resetPopulationFlags()
                populatingColorListName = true
            case .none:
                if populatingColorListName {
                    colorListName = CommandLine.arguments[index]
                }
                if populatingConfigURL {
                    let url = CommandLine.arguments[index]
                    if url.lowercased().starts(with: "https") ||
                        url.lowercased().starts(with: "http") {
                        configURL = URL(string: url)
                    } else {
                        configURL = URL(fileURLWithPath: url)
                    }
                }
            }
        }
        guard let configurationURL = configURL, let colorList = colorListName else {
            print("Must specify --color-list and --config-url arguments")
            return
        }
        processArguments(configURL: configurationURL, colorListName: colorList)
    }

    private func processArguments(configURL: URL, colorListName: String) {
        TypographyKit.configurationURL = configURL
        TypographyKit.refresh()
        let colorList = NSColorList(name: colorListName)
        TypographyKit.colors.sorted(by: { (arg1, arg2) in
            let (colorName, _) = arg1, (colorName2, _) = arg2
            return colorName < colorName2
        }).forEach { (arg) in
            let (colorName, color) = arg
            colorList.setColor(color, forKey: colorName.capitalized())
        }
        var outputURL = FileManager.default.homeDirectoryForCurrentUser
            outputURL = outputURL
            .appendingPathComponent("Library")
            .appendingPathComponent("Colors")
            .appendingPathComponent("\(colorListName).clr")
        try? colorList.write(to: outputURL)
        exit(0)
    }
}
