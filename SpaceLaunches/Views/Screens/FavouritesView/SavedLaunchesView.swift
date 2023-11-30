//
//  SavedLaunchesView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 16/11/2023.
//

import SwiftUI

struct SavedLaunchesView: View {
    
    @State var favouriteLaunches: [Launch] = []
    
    var body: some View {
            if favouriteLaunches.isEmpty {
                Text("No Favourite Launches")
                    .onAppear {
                        do {
                            try LaunchFavouriteStore.shared.load()
                            favouriteLaunches = LaunchFavouriteStore.shared.favouriteLaunches
                        } catch {
                            
                        }
                    }
            } else {
                List {
                    ForEach(favouriteLaunches) { launch in
                        NavigationLink(destination: LaunchDetailView(launch: launch)) {
                            LaunchCell(launch: launch)
                        }
                    }
                }
                .listStyle(.plain)
                .onAppear {
                    do {
                        try LaunchFavouriteStore.shared.load()
                        favouriteLaunches = LaunchFavouriteStore.shared.favouriteLaunches
                    } catch {
                        
                    }
                }
            }
    }
}

#Preview {
    SavedLaunchesView()
}
