//
//  LaunchDetailView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 01/10/2023.
//

import SwiftUI
import Kingfisher
import MapKit

struct LaunchDetailView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    let launch: Launch
    
    
    var body: some View {
        GeometryReader { geo in
        
            ScrollView {
                
                KFImage(URL(string: launch.image ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(height: 500)
                    .frame(maxWidth: geo.size.width)
                    .overlay(alignment: .bottom) {
                        
                        CountdownTimerView(launchTime: launch.net)
                            .frame(alignment: .center)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.ultraThinMaterial)
                                
                            }
                            .padding()
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
                        .frame(width: 90)
                    }
                    .foregroundColor(.secondary)
                    
                    Divider()
                        .padding()
                    
                    if let mission = launch.mission {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Mission")
                                .font(.title2)
                                .bold()
                            Text(mission.name)
                                .bold()
                  
                            Text(mission.description)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Agency")
                            .font(.title2)
                            .bold()
                        Text(launch.launchServiceProvider.name)
                            .bold()
                        Text(launch.launchServiceProvider.description)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Rocket")
                            .font(.title2)
                            .bold()
                        Text(launch.rocket.configuration.name)
                            .bold()
                        Text(launch.rocket.configuration.description)
                            .foregroundColor(.secondary)
                        
                    }
                    
                    Divider()
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Location")
                            .font(.title2)
                            .bold()
                        if let pad = launch.pad {
                                Map(coordinateRegion: $region, annotationItems: [pad.launchLocation]) { location in
                                    MapMarker(coordinate: location.coordinate)
                                }
                                    .frame(maxWidth: geo.size.width)
                                    .frame(height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                    .padding(.top)
                                    .onAppear {
                                        region.center.latitude = pad.latitudeDeg
                                        region.center.longitude = pad.longitudeDeg
                                    }
                                Text(pad.location.name)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity)
                            
                        }
                    }
                
                
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}

struct LaunchLocation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct LaunchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchDetailView(launch: Launch.example())
        
    }
}
