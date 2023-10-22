//
//  AgencyDetailView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 17/10/2023.
//

import SwiftUI
import Kingfisher

struct AgencyDetailView: View, DetailView {
    
    let agency: LaunchServiceProvider
    
    var body: some View {
        ScrollView {
            VStack {
                KFImage(URL(string: agency.logoUrl ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding()
                    .background {
                        Circle()
                            .foregroundColor(.white)
                    }
                    .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("About")
                        .font(.title)
                        .bold()
                    Text(agency.description)
                        .foregroundColor(.gray)
                    
                    if let infoUrl = agency.infoUrl {
                        if let url = URL(string: infoUrl) {
                            Link(destination: url, label: {
                                Label("Read more", systemImage: "safari")
                            })
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    Text("Details")
                        .font(.title)
                        .bold()
                    if let administrator = agency.administrator {
                        DetailListCell(detailTitle: "CEO", text: administrator.replacingOccurrences(of: "CEO: ", with: ""))
                    }
                    DetailListCell(detailTitle: "Founding Year", text: agency.foundingYear)
                    
                    if let agencyType = agency.type {
                        DetailListCell(detailTitle: "Type", text: agencyType)
                    }
                    
                    DetailListCell(detailTitle: "Country", text: agency.countryCode)
                    
                    DetailListCell(detailTitle: "Total Launches", text: String(agency.totalLaunchCount))
                    
                    DetailListCell(detailTitle: "Successful Launches", text: String(agency.successfulLaunches))


                }
            }
            .padding()
        }
        .navigationTitle(agency.name)
    }
}

protocol DetailView {
    
}

#Preview {
    NavigationView {
        AgencyDetailView(agency: LaunchServiceProvider.launchServiceProviderExample())
    }
}

