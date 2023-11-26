//
//  FavouritesWidget.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 25/11/2023.
//

import WidgetKit
import SwiftUI
import Kingfisher

struct FavouritesProvider: TimelineProvider {
    
    let service = APIService()
    
    func placeholder(in context: Context) -> LaunchEntry {
        LaunchEntry(date: Date(), launch: Launch.example(), backgroundImageDate: Data())
    }

    func getSnapshot(in context: Context, completion: @escaping (LaunchEntry) -> ()) {
        let entry = LaunchEntry(date: Date(), launch: Launch.example(), backgroundImageDate: Data())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        if let data = UserDefaults.shared.value(forKey: UserDefaults.launchKey) as? Data {
            do {
                let decodedFavourites = try JSONDecoder().decode([Launch].self, from: data)
                let firstFav = decodedFavourites.first
                service.getDataFromUrl(url: firstFav?.image ?? "") { data, response, error in
                    if let data = data {
                        let entry = LaunchEntry(date: Date(), launch: firstFav ?? Launch.example(), backgroundImageDate: data)
                        let timeline = Timeline(entries: [entry], policy: .after(firstFav!.net.convertToDate() ?? Date().addingTimeInterval(21600)))
                        completion(timeline)
                    }
                }
            } catch {
                
            }
        }
    }
}

struct FavouritesWidgetEntryView : View {
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

struct FavouritesWidget: Widget {
    let kind: String = "FavouritesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FavouritesProvider()) { entry in
            if #available(iOS 17.0, *) {
                FavouritesWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                FavouritesWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Favourite Launch")
        .description("Keep track of your favourite launch")
        .supportedFamilies([.systemMedium, .systemSmall, .systemLarge])
        .contentMarginsDisabled()


    }
}

#Preview(as: .systemLarge) {
    FavouritesWidget()
} timeline: {
    LaunchEntry(date: .now, launch: Launch.example(), backgroundImageDate: Data())
}
#Preview(as: .systemMedium) {
    FavouritesWidget()
} timeline: {
    LaunchEntry(date: .now, launch: Launch.example(), backgroundImageDate: Data())
}

#Preview(as: .systemSmall) {
    FavouritesWidget()
} timeline: {
    LaunchEntry(date: .now, launch: Launch.example(), backgroundImageDate: Data())
}
