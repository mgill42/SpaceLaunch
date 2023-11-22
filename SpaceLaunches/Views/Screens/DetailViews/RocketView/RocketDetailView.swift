//
//  RocketDetailView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 21/10/2023.
//

import SwiftUI
import Kingfisher

struct RocketDetailView: View {
    
    let rocket: Rocket
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
               RocketImage(rocket: rocket, geo: geo)
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    RocketAbout(rocket: rocket)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    RocketStats(rocket: rocket)
                }
                .padding()
            }
        }
        .navigationTitle(rocket.configuration.name)
    }
}

#Preview {
    NavigationView {
        RocketDetailView(rocket: Rocket.rocketExample())
    }
}

struct RocketImage: View {
    let rocket: Rocket
    let geo: GeometryProxy
    var body: some View {
        if let imageURL = rocket.configuration.imageUrl {
            KFImage(URL(string: imageURL))
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .scaledToFill()
                .frame(height: 500)
                .frame(maxWidth: geo.size.width)
        } else {
            Image("rocketPlaceholder")
                .resizable()
                .scaledToFill()
                .frame(height: 500)
                .frame(maxWidth: geo.size.width)
        }
    }
}

struct RocketAbout: View {
    
    let rocket: Rocket
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("About")
                .font(.title)
                .bold()
            
            Text(rocket.configuration.description)
                .foregroundColor(.gray)
            
            if let infoUrl = rocket.configuration.infoUrl {
                if let url = URL(string: infoUrl) {
                    Link(destination: url, label: {
                        Label("Read more", systemImage: "safari")
                    })
                }
            }
        }
    }
}

struct RocketStats: View {
    
    let rocket: Rocket
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Statistics")
                .font(.title)
                .bold()
            if let length = rocket.configuration.length {
                DetailListCell(detailTitle: "Length", text: "\(length) meters")
            }
            
            if let diameter = rocket.configuration.diameter {
                DetailListCell(detailTitle: "Diameter", text: "\(diameter) meters")
            }
            
            if let mass = rocket.configuration.launchMass {
                DetailListCell(detailTitle: "Mass", text: "\(mass) tonnes")
            }
            
            if let thrust = rocket.configuration.toThrust {
                DetailListCell(detailTitle: "Thrust", text: "\(thrust)kn")
            }
            
            DetailListCell(detailTitle: "Active", text: rocket.configuration.active ? "Yes" : "No")
            
            if let maidenFlight = rocket.configuration.maidenFlight {
                DetailListCell(detailTitle: "Maiden Flight", text: maidenFlight)
            }
            
            DetailListCell(detailTitle: "Total Launches", text: String(rocket.configuration.totalLaunchCount))
            
            DetailListCell(detailTitle: "Successful Launches", text: String(rocket.configuration.successfulLaunches))
            
            DetailListCell(detailTitle: "Failed Launches", text: String(rocket.configuration.failedLaunches))
            
            DetailListCell(detailTitle: "Landings", text: String(rocket.configuration.attemptedLandings))
            
            DetailListCell(detailTitle: "Successful Landings", text: String(rocket.configuration.successfulLandings))
            
            DetailListCell(detailTitle: "Failed Landings", text: String(rocket.configuration.failedLandings))
            
            if let leo = rocket.configuration.leoCapacity {
                DetailListCell(detailTitle: "LEO Capacity", text: "\(leo)kg")
            }
            
            if let gto = rocket.configuration.gtoCapacity {
                DetailListCell(detailTitle: "GEO Capacity", text: "\(gto)kg")
            }
        }
    }
}
