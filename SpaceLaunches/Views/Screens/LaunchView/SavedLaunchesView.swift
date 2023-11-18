//
//  SavedLaunchesView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 16/11/2023.
//

import SwiftUI

struct SavedLaunchesView: View {
    
    @StateObject private var launchStore = LaunchFavouriteStore()

    var body: some View {
        Group {
            if launchStore.favouriteLaunches.isEmpty {
                Text("No Favourite Launches")
                
            } else {
                List {
                    ForEach(launchStore.favouriteLaunches) { launch in
                        NavigationLink(destination: LaunchDetailView(launch: launch)) {
                            LaunchCell(launch: launch)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
        }
        .task {
            do {
                try await launchStore.load()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    SavedLaunchesView()
}
