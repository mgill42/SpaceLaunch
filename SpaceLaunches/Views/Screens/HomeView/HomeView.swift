//
//  HomeView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 25/09/2023.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                switch viewModel.state {
                case .isLoading:
                    ProgressView()
                case .good:
                    Color.clear
                        .onAppear {
                            viewModel.fetchHighlightLaunch()
                        }
                case .loadedAll:
                    if let highlightedLaunch = viewModel.highLightedLaunch {
                        HighlightLaunchView(launch: highlightedLaunch)
                    }
                case .error(let message):
                    Text(message)
                        .foregroundColor(.pink)
                }
            }
            .navigationTitle("Upcoming Launch")

        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}