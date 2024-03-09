//
//  pokedex3WidgetLiveActivity.swift
//  pokedex3Widget
//
//  Created by Manolo on 01/03/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct pokedex3WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct pokedex3WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: pokedex3WidgetAttributes.self) { context in
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

extension pokedex3WidgetAttributes {
    fileprivate static var preview: pokedex3WidgetAttributes {
        pokedex3WidgetAttributes(name: "World")
    }
}

extension pokedex3WidgetAttributes.ContentState {
    fileprivate static var smiley: pokedex3WidgetAttributes.ContentState {
        pokedex3WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: pokedex3WidgetAttributes.ContentState {
         pokedex3WidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: pokedex3WidgetAttributes.preview) {
   pokedex3WidgetLiveActivity()
} contentStates: {
    pokedex3WidgetAttributes.ContentState.smiley
    pokedex3WidgetAttributes.ContentState.starEyes
}
