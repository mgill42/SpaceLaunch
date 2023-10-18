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
            HStack {
                KFImage(URL(string: agency.logoUrl ?? ""))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding()
                Text(agency.name)
            }
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
