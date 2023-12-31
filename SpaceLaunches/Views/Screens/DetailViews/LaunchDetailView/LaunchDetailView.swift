//
//  LaunchDetailView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 01/10/2023.
//

import SwiftUI
import MapKit
import Kingfisher

struct LaunchDetailView: View {
        
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
    
    
    let launch: Launch
    
    @State var missionMore = false
    @State var agencyMore = false
    @State var rocketMore = false
    

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                if let imageURL = launch.image {
                    KFImage(URL(string: imageURL))
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(height: 500)
                        .frame(maxWidth: geo.size.width)
                        .overlay(alignment: .bottom) {
                            CountdownTimerView(launchTime: launch.net)
                        }
                        .overlay(alignment: .topTrailing) {
                            FavouriteButton(launch: launch)
                                .padding()
                        }
                } else {
                    Image("rocketPlaceholder")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 500)
                        .frame(maxWidth: geo.size.width)
                        .overlay(alignment: .bottom) {
        
                            CountdownTimerView(launchTime: launch.net)
                         
                        }
                }
                    
                VStack(alignment: .leading) {

                    VStack(alignment: .leading) {
                        Text(launch.name)
                            .font(.title)
                            .bold()
                        Text(launch.launchServiceProvider.name)
                            .font(.title2)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
    
                    Grid {
                        GridRow {
                            Text("Date")
                            Text("Time")
                            Text("Status")
                        }
                        .frame(width: 90)
                        .padding(10)
                        
                        
                        GridRow {
                            Text(launch.net.formattedDate(dateStyle: .short, timeStyle: .none))
                                .bold()
                            Text(launch.net.formattedDate(dateStyle: .none, timeStyle: .short))
                                .bold()
                            Text(launch.status.abbrev)
                                .bold()
                        }
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                        .frame(width: 90)
                    }
                    .foregroundColor(.secondary)
                    
                    Divider()
                        .padding()
                    
                    if let mission = launch.mission {
                        LaunchDetailSection(name: mission.name, description: mission.description, toggleState: $missionMore, destination: MissionDetailView(mission: mission, missionPatch: launch.missionPatches.first), title: "Mission")
                    }
                    
                    Divider()
                        .padding()
        
                    
                    LaunchDetailSection(name: launch.launchServiceProvider.name, description: launch.launchServiceProvider.description, toggleState: $agencyMore, destination: AgencyDetailView(agency: launch.launchServiceProvider), title: "Agency")
                   
                    
                    Divider()
                        .padding()
                    
                    LaunchDetailSection(name: launch.rocket.configuration.name, description: launch.rocket.configuration.description, toggleState: $rocketMore, destination: RocketDetailView(rocket: launch.rocket), title: "Rocket")
                    
                    Divider()
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Location")
                            .font(.title2)
                            .bold()
                        if let pad = launch.pad {
                            LaunchMapView(cameraPosition: $cameraPosition, geo: geo, pad: pad)
                        }
                    }
                    
                    Divider()
                    
                    if !launch.vidURLs.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Videos")
                                .font(.title2)
                                .bold()
                            
                            ForEach(launch.vidURLs) { vid in
                                if let url = URL(string:vid.url) {
                                    Link(destination: url) {
                                        if let imageUrl = vid.feature_image {
                                            KFImage(URL(string: imageUrl))
                                                .placeholder {
                                                    ProgressView()
                                                }
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                                .overlay {
                                                    Image(systemName: "play.fill")
                                                        .font(.system(size: 60))
                                                        .foregroundColor(.white)
                                                        .offset(y: 10)
                                                        .opacity(0.5)
                                                }
                                        } else {
                                            VideoPlayerView(vidUrl: vid)
                                        }
                                    }
                                    .padding(.vertical)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct LaunchDetailSection<Content: View>: View {
    
    let name: String
    let description: String
    @Binding var toggleState: Bool
    let destination: Content
    let title: String
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            NavigationLink(destination: destination ) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.title2)
                            .bold()
                            .lineLimit(1)
                            .foregroundColor(.primary)
                        Text(title)
                            .lineLimit(1)
                            .foregroundColor(.gray)

                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }
            
            Group {
                ViewThatFits(in: .vertical) {
                    Text(description)
                        .foregroundColor(.secondary)
                    
                    ZStack(alignment: .bottomTrailing) {
                        
                        Text(description)
                            .foregroundColor(.secondary)
                                                
                        Button("more") {
                            withAnimation {
                                toggleState = true
                            }
                        }
                        .foregroundColor(.blue)
                        .opacity(toggleState ? 0 : 1)
                        .padding(.leading, 30)
                        .background {
                            LinearGradient(gradient: Gradient(colors: [Color(uiColor: .systemBackground), Color(uiColor: .systemBackground), .clear]), startPoint: .trailing, endPoint: .leading)
                        }
                    }
                }
            }
            .frame(maxHeight: toggleState ? .infinity : 70, alignment: .topLeading)
            
        }
    }
}

struct VideoPlayerView: View {
    
    let vidUrl: VidURL
    
    var body: some View {
        
        VStack {
            if let featureImage = vidUrl.feature_image {
                if let url = URL(string: featureImage) {
                    KFImage(url)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
            } else {
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(Color(uiColor: .secondarySystemBackground))
                    .frame(height: 200)
                    .overlay {
                        Image(systemName: "play.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                            .offset(y: 10)
                    }
                    .overlay(alignment: .topLeading) {
                        Text(vidUrl.title)
                            .font(.title2)
                            .bold()
                            .padding()
                            .lineLimit(1)
                    }
            }
        }
    }
}

#Preview("LaunchDetailView") {
    LaunchDetailView(launch: Launch.example())
}


#Preview("VideoPlayerView") {
    VideoPlayerView(vidUrl: VidURL.vidURLExample())
    
}


struct FavouriteButton: View {
    
    @State var favourited = false

    let launch: Launch

    var body: some View {
        Button {
            Task {
                if favourited {
                    try LaunchFavouriteStore.shared.delete(launch: launch)
                    favourited = false
                } else {
                    try LaunchFavouriteStore.shared.save(launch: launch)
                    favourited = true
                }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(Color(uiColor: .secondarySystemBackground))
                    .frame(width: 40, height: 40)
                    .opacity(0.5)
                Group {
                    if favourited {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.accentColor)
                    } else {
                        Image(systemName: "heart")
                            .foregroundColor(.accentColor)
                    }
                }
                .font(.title2)
            }
        }
        .onAppear {
            let isFavourited = LaunchFavouriteStore.shared.checkIfFavourite(launch: launch)
            if isFavourited || favourited {
                favourited = true
            } else {
               favourited = false
            }
        }
    }
}

struct LaunchMapView: View {
    
    @Binding var cameraPosition: MapCameraPosition
    let geo: GeometryProxy
    let pad: Pad
    
    var body: some View {
        VStack {
            Map(position: $cameraPosition) {
                Marker(pad.location.name, coordinate: pad.launchLocation.coordinate)
            }
            .frame(maxWidth: geo.size.width)
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .padding(.top)
            .onAppear {
                let position = MapCameraPosition.region(MKCoordinateRegion(center: pad.launchLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
                cameraPosition = position
                
            }
            Text(pad.location.name)
                .font(.footnote)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
        }
    }
}
