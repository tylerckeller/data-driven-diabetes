//
//  StreakWidge.swift
//  StreakWidge
//
//  Created by Colton Morris on 2/10/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct StreakWidgeEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
    }
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

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
    
    fileprivate static var calendar: ConfigurationAppIntent{
        let intent = ConfigurationAppIntent()
        intent.data = 
    }
}

struct GoalSquareView: View {
    var percentage: Double // From 0.0 to 1.0

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(percentage: percentage))
            .frame(width: 20, height: 20)
    }
}

extension Color {
    init(percentage: Double) {
        self = percentage == 1.0 ? .green : .gray
        // You can adjust the color to show gradients based on the percentage
    }
}

struct WidgetContentView: View {
    var entries: [user] // Your data model array

    var body: some View {
        // Define columns for your grid
        let columns = [GridItem](repeating: GridItem(.flexible(), spacing: 4), count: 6) // Adjust for your grid size

        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(entries) { entry in
                GoalSquareView(percentage: entry.percentage)
            }
        }
        .padding(.all)
    }
}





















#Preview(as: .systemSmall) {
    StreakWidge()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
