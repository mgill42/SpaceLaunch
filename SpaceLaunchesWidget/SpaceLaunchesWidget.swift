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
    
    let service = APIService()
    
    func placeholder(in context: Context) -> LaunchEntry {
        LaunchEntry(date: Date(), launch: Launch.example(), backgroundImageDate: Data())
    }

    func getSnapshot(in context: Context, completion: @escaping (LaunchEntry) -> ()) {
        let entry = LaunchEntry(date: Date(), launch: Launch.example(), backgroundImageDate: Data())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [LaunchEntry] = []

        service.fetchHighlightLaunch { result in
            switch result {
            case .success(let success):
                service.getDataFromUrl(url: success.image ?? "") { data, response, error in
                    if let data = data {
                        entries.append(LaunchEntry(date: Date(), launch: success, backgroundImageDate: data))
                        let timeline = Timeline(entries: entries, policy: .atEnd)
                        completion(timeline)
                    }
                }
            case .failure(_):
                print("failed")
                return
            }
        }
     
    }
}

struct LaunchEntry: TimelineEntry {
    let date: Date
    let launch: Launch
    let backgroundImageDate: Data
}

struct SpaceLaunchesWidgetEntryView : View {
    var entry: LaunchEntry

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Image(uiImage: UIImage(data: entry.backgroundImageDate) ?? UIImage(named: "rocketPlaceholder")!)
                    .resizable()
                    .scaledToFill()
                
                Text(entry.launch.name)
                    .foregroundColor(.white)
                    .bold()
                    .padding([.top, .leading])
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(width: geo.size.width * 0.8)
            }
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
        .contentMarginsDisabled()
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])

    }
}

#Preview(as: .systemMedium) {
    SpaceLaunchesWidget()
} timeline: {
    LaunchEntry(date: .now, launch: Launch.example(), backgroundImageDate: Data())
}
