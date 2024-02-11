//
//  StreakWidge.swift
//  StreakWidge
//
//  Created by Colton Morris on 2/10/24.
//

import WidgetKit
import SwiftUI

struct StreakWidgeEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Date: \(entry.date)")
            Text("Streak: \(entry.streak)")
        }
    }
}

struct Provider: TimelineProvider, AppIntentTimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        guard let userDefaults = UserDefaults(suiteName: "group.com.data-driven-diabetes") else {
            return SimpleEntry(date: Date(), streak: 0)
        }
        
        let streak = userDefaults.integer(forKey: "streak")
        return SimpleEntry(date: Date(), streak: streak)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), streak: 0)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        if let userDefaults = UserDefaults(suiteName: "group.com.data-driven-diabetes") {
            let streak = userDefaults.integer(forKey: "streak")
            
            entries.append(SimpleEntry(date: Date(), streak: streak))
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let streak: Int
}


struct StreakWidge: Widget {
    let kind: String = "StreakWidge"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            StreakWidgeEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}
