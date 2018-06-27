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
    
    init(argument: String) {
        switch argument {
        case CommandLineArgument.configURL.rawValue, CommandLineArgument.configURLShorthand.rawValue:
            self = .configURL
        case CommandLineArgument.colorListName.rawValue, CommandLineArgument.colorListNameShorthand.rawValue:
            self = .colorListName
        default:
            self = .none
        }
    }
}
