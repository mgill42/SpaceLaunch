//
//  FavouritesWidget.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 25/11/2023.
//

import WidgetKit
import SwiftUI
import Kingfisher

struct FavouritesProvider: AppIntentTimelineProvider {
    
    let service = APIService()
    
    func placeholder(in context: Context) -> FavLaunchEntry {
        FavLaunchEntry(date: Date(), launch: LaunchEntity.example, backgroundImageDate: Data(), noFavourites: false)
    }
    
    func snapshot(for configuration: SelectFavouriteLaunch, in context: Context) async -> FavLaunchEntry {
        FavLaunchEntry(date: Date(), launch: LaunchEntity.example, backgroundImageDate: Data(), noFavourites: false)
    }
    
    func timeline(for configuration: SelectFavouriteLaunch, in context: Context) async -> Timeline<FavLaunchEntry> {
        if let launch = configuration.launch {
            if let imageURL = launch.image {
                do {
                    let data = await service.getDataFromUrl(url: imageURL)
                    return Timeline(entries: [FavLaunchEntry(date: Date(), launch: launch, backgroundImageDate: data, noFavourites: false)], policy: .never)
                }
            }
        }
        return Timeline(entries: [FavLaunchEntry(date: Date(), launch: LaunchEntity.example, backgroundImageDate: Data(), noFavourites: true)], policy: .never)
    }
}

struct FavLaunchEntry: TimelineEntry {
    let date: Date
    let launch: LaunchEntity
    let backgroundImageDate: Data
    let noFavourites: Bool
}

struct FavouritesWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: FavLaunchEntry

    var body: some View {
        if entry.noFavourites {
            
            ZStack {
                Color.black
                Text("No Favourites")
                    .foregroundColor(.white)
                    .font(.title)
                    .multilineTextAlignment(.center)
            }
 
        } else {
            switch family {
            case .systemSmall:
                FavWidgetSmallView(entry: entry)
            case .systemMedium:
                FavWidgetMediumView(entry: entry)
            case .systemLarge:
                FavWidgetLargeView(entry: entry)
            default:
                EmptyView()
            }
        }
    }
}

struct FavouritesWidget: Widget {
    let kind: String = "FavouritesWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SelectFavouriteLaunch.self,
            provider: FavouritesProvider())
        { entry in
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
    FavLaunchEntry(date: .now, launch: LaunchEntity.example, backgroundImageDate: Data(), noFavourites: false)
    FavLaunchEntry(date: .now, launch: LaunchEntity.example, backgroundImageDate: Data(), noFavourites: true)
}
#Preview(as: .systemMedium) {
    FavouritesWidget()
} timeline: {
    FavLaunchEntry(date: .now, launch: LaunchEntity.example, backgroundImageDate: Data(), noFavourites: false)
    FavLaunchEntry(date: .now, launch: LaunchEntity.example, backgroundImageDate: Data(), noFavourites: true)
}
#Preview(as: .systemSmall) {
    FavouritesWidget()
} timeline: {
    FavLaunchEntry(date: .now, launch: LaunchEntity.example, backgroundImageDate: Data(), noFavourites: false)
    FavLaunchEntry(date: .now, launch: LaunchEntity.example, backgroundImageDate: Data(), noFavourites: true)
}

struct FavWidgetSmallView: View {
    let entry: FavLaunchEntry
    
    var body: some View {

        VStack {
            VStack(alignment: .leading) {
                Text(entry.launch.name)
                    .foregroundColor(.white)
                    .bold()
                
                if let launchDate = entry.launch.net.convertToDate() {
                    Text(launchDate, style: .timer)
                        .bold()
                        .foregroundColor(.white)
                }
                
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "heart.fill")
                        .foregroundColor(.orange)
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

struct FavWidgetMediumView: View {
    let entry: FavLaunchEntry
    
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
                    
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .foregroundColor(.orange)
                            .font(.title)
                    }
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

struct FavWidgetLargeView: View {
    let entry: FavLaunchEntry
    
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
                    
                    Text(entry.launch.launchServiceProvier.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    if let pad = entry.launch.pad {
                        Text(pad.location.name)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .foregroundColor(.orange)
                            .font(.largeTitle)
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

