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
                        let timeline = Timeline(entries: entries, policy: .after(success.net.convertToDate() ?? Date().addingTimeInterval(21600)))
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
    @Environment(\.widgetFamily) var family
    var entry: LaunchEntry

    var body: some View {
        switch family {
        case .systemSmall:
            LaunchWidgetSmallView(entry: entry)
        case .systemMedium:
            LaunchWidgetMediumView(entry: entry)
        case .systemLarge:
            LaunchWidgetLargeView(entry: entry)
        default:
            EmptyView()
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
        .configurationDisplayName("Space Launch")
        .description("Keep track of the latest launch")
        .supportedFamilies([.systemMedium, .systemSmall, .systemLarge])
        .contentMarginsDisabled()


    }
}

#Preview(as: .systemLarge) {
    SpaceLaunchesWidget()
} timeline: {
    LaunchEntry(date: .now, launch: Launch.example(), backgroundImageDate: Data())
}
#Preview(as: .systemMedium) {
    SpaceLaunchesWidget()
} timeline: {
    LaunchEntry(date: .now, launch: Launch.example(), backgroundImageDate: Data())
}

#Preview(as: .systemSmall) {
    SpaceLaunchesWidget()
} timeline: {
    LaunchEntry(date: .now, launch: Launch.example(), backgroundImageDate: Data())
}

struct LaunchWidgetSmallView: View {
    let entry: LaunchEntry
    
    var body: some View {

        VStack() {
            VStack(alignment: .leading) {
                Text(entry.launch.name)
                    .foregroundColor(.white)
                    .bold()
                
                if let launchDate = entry.launch.net.convertToDate() {
                    Text(launchDate, style: .timer)
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .padding()
            Spacer()
        }
        .background {
            Image(uiImage: UIImage(data: entry.backgroundImageDate) ?? UIImage(named: "rocketPlaceholder")!)
                .resizable()
                .scaledToFill()
                .overlay {
                    LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .top, endPoint: .bottom)
                        .opacity(0.6)
                }
        }
    }
}

struct LaunchWidgetMediumView: View {
    let entry: LaunchEntry
    
    var body: some View {

        VStack() {
            VStack(alignment: .leading) {
                Text(entry.launch.name)
                    .font(.title2)
                    .foregroundColor(.white)
                    .bold()
                
                if let launchDate = entry.launch.net.convertToDate() {
                    Text(launchDate, style: .timer)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .padding()
            Spacer()
        }
        .background {
            Image(uiImage: UIImage(data: entry.backgroundImageDate) ?? UIImage(named: "rocketPlaceholder")!)
                .resizable()
                .scaledToFill()
                .overlay {
                    LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .top, endPoint: .bottom)
                        .opacity(0.6)
                }
        }
    }
}

struct LaunchWidgetLargeView: View {
    let entry: LaunchEntry
    
    var body: some View {

        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(entry.launch.name)
                        .font(.title)
                        .foregroundColor(.white)
                        .bold()
                    
                    if let launchDate = entry.launch.net.convertToDate() {
                        Text(launchDate, style: .timer)
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                    }
                    
                    Text(entry.launch.launchServiceProvider.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    if let pad = entry.launch.pad {
                        Text(pad.location.name)
                            .foregroundColor(.white)
                    }
          
                }
                Spacer()
            }
            Spacer()
            }
            .padding()
            .background {
                Image(uiImage: UIImage(data: entry.backgroundImageDate) ?? UIImage(named: "rocketPlaceholder")!)
                    .resizable()
                    .scaledToFill()
                    .overlay {
                        LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .top, endPoint: .bottom)
                            .opacity(0.6)
                    }
            }
        
       
    }
}
