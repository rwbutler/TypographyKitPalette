//
//  CommandLineProcessor.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/29/18.
//

import Foundation
import AppKit

struct CommandLineProcessor {

    var colorListName: String?
    var configURL: URL?
    var populatingColorListName = false
    var populatingConfigURL = false

    mutating func main() {
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
        print("Must specify --color-list and --config-url arguments")
    }

    private mutating func processArgument(_ argumentString: String) {
        let argument = CommandLineArgument(argument: argumentString)
        switch argument {
        case .configURL, .configURLShorthand:
            resetPopulationFlags()
            populatingConfigURL = true
        case .colorListName, .colorListNameShorthand:
            resetPopulationFlags()
            populatingColorListName = true
        case .none:
            if populatingColorListName {
                colorListName = argumentString
            }
            if populatingConfigURL {
                let urlString = argumentString
                configURL = url(urlString: urlString)
            }
        }
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

    private mutating func resetPopulationFlags() {
        populatingColorListName = false
        populatingConfigURL = false
    }

    private func url(urlString: String) -> URL? {
        if isHTTPURL(urlString: urlString) {
            return URL(string: urlString)
        } else {
            return URL(fileURLWithPath: urlString)
        }
    }

}
