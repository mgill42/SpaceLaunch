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
        GeometryReader { geo in
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
                                .padding(.top, 30)
                        }
                    case .error:
                        ErrorPlaceholderView()
                            .frame(height: geo.size.height / 1.3)
                            .frame(maxWidth: .infinity)
                    case .isEmpty:
                        HighlightLaunchLoadingView()
                            .frame(height: geo.size.height / 1.3)
                    }
                }
                .scrollIndicators(.hidden)
                .navigationTitle("Upcoming Launch")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
