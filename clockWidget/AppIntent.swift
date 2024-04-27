//
//  AppIntent.swift
//  clockWidget
//
//  Created by  玉城 on 2024/4/23.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Quote", default: "less is more")
    var favoriteEmoji: String
}
