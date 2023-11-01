//
//  SpaceLaunchesWidget.swift
//  SpaceLaunchesWidget
//
//  Created by Mahaveer Gill on 01/11/2023.
//

import WidgetKit
import SwiftUI
import Kingfisher

struct Provider: TimelineProvider {
    
    
    func placeholder(in context: Context) -> LaunchEntry {
        LaunchEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (LaunchEntry) -> ()) {
        let entry = LaunchEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [LaunchEntry] = []
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct LaunchEntry: TimelineEntry {
    let date: Date
}

struct SpaceLaunchesWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
        }
    }
}

struct SpaceLaunchesWidget: Widget {
    let kind: String = "SpaceLaunchesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                SpaceLaunchesWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SpaceLaunchesWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    SpaceLaunchesWidget()
} timeline: {
    LaunchEntry(date: .now)
    LaunchEntry(date: .now)
}
