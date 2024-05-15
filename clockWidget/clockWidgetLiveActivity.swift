
//
//  clockWidgetLiveActivity.swift
//  clockWidget
//
//  Created by  玉城 on 2024/4/23.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct clockWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}



struct clockWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: clockWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension clockWidgetAttributes {
    fileprivate static var preview: clockWidgetAttributes {
        clockWidgetAttributes(name: "World")
    }
}

extension clockWidgetAttributes.ContentState {
    fileprivate static var smiley: clockWidgetAttributes.ContentState {
        clockWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: clockWidgetAttributes.ContentState {
         clockWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: clockWidgetAttributes.preview) {
   clockWidgetLiveActivity()
} contentStates: {
    clockWidgetAttributes.ContentState.smiley
    clockWidgetAttributes.ContentState.starEyes
}
