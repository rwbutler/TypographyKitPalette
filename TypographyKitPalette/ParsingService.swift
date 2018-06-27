//
//  ParsingService.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

import AppKit

protocol ParsingService {
    func parse(_ data: Data) -> ParsingServiceResult?
}

extension ParsingService {
    func parse(_ configEntries: [String: Any]) -> ParsingServiceResult? {
        var configuration: ConfigurationSettings = ConfigurationSettings(pointStepSize: 2.0,
                                                                         pointStepMultiplier: 1.0)
        var typographyColors: [String: NSColor] = [:]

        if let typographyKitConfig = configEntries["typography-kit"] as? [String: Float],
            let pointStepSize = typographyKitConfig["point-step-size"],
            let pointStepMultiplier = typographyKitConfig["point-step-multiplier"] {
            configuration = ConfigurationSettings(pointStepSize: pointStepSize,
                                                  pointStepMultiplier: pointStepMultiplier)
        }
        if let typographyColorNames = configEntries["typography-colors"] as? [String: String] {
            for (key, value) in typographyColorNames {
                typographyColors[key] = TypographyColor(string: value)?.NSColor
            }
        }
        return (configurationSettings: configuration,
                typographyColors: typographyColors)
    }
}
