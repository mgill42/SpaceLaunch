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
    
    let launch: Launch
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
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
                    .foregroundColor(.gray)
                    
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
                                .foregroundColor(.gray)
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
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Location")
                            .font(.title2)
                            .bold()
                        if let pad = launch.pad {
                            if let latitude = launch.pad?.latitude, let longitude = launch.pad?.longitude {
                                Map(coordinateRegion: $region)
                                    .frame(maxWidth: geo.size.width)
                                    .frame(height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                    .onAppear {
                                        region.center.latitude = Double(latitude) ?? 0.0
                                        region.center.longitude = Double(longitude) ?? 0.0
                                        
                                    }
                                Text(pad.location.name)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity)
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

struct LaunchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchDetailView(launch: Launch.example())
        
    }
}
