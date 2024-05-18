//
//  AppIntent.swift
//  clockWidget
//
//  Created by  玉城 on 2024/4/23.
//

import WidgetKit
import AppIntents

//@available(iOSApplicationExtension 17.0, *)
//struct ConfigurationAppIntent: WidgetConfigurationIntent {
//    static var title: LocalizedStringResource = "Quote"
//    static var description = IntentDescription("less is more.")
//
//    // An example configurable parameter.
//    @Parameter(title: "Quote", default: "less is more")
//    var favoriteEmoji: String
//}

@available(iOSApplicationExtension 17.0, *)
struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Quote"
    static var description = IntentDescription("less is more.")

    // An example configurable parameter.
    @Parameter(title: "Quote", default: "less is more")
    internal var favoriteEmoji: String
}
