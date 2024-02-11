//
//  StreakWidgeLiveActivity.swift
//  StreakWidge
//
//  Created by Colton Morris on 2/10/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct StreakWidgeAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct StreakWidgeLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StreakWidgeAttributes.self) { context in
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

extension StreakWidgeAttributes {
    fileprivate static var preview: StreakWidgeAttributes {
        StreakWidgeAttributes(name: "World")
    }
}

extension StreakWidgeAttributes.ContentState {
    fileprivate static var smiley: StreakWidgeAttributes.ContentState {
        StreakWidgeAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: StreakWidgeAttributes.ContentState {
         StreakWidgeAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: StreakWidgeAttributes.preview) {
   StreakWidgeLiveActivity()
} contentStates: {
    StreakWidgeAttributes.ContentState.smiley
    StreakWidgeAttributes.ContentState.starEyes
}
