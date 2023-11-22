//
//  HomeView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 25/09/2023.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewModel = HomeViewModel()
    

    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ScrollView {
                    switch viewModel.state {
                    case .isLoading:
                        HighlightLaunchLoadingView()
                            .frame(height: geo.size.height / 1.3)
                    case .good:
                        Color.clear
                            .onAppear {
                                viewModel.fetchHighlightLaunch()
                            }
                    case .loadedAll:
                        if let highlightedLaunch = viewModel.highLightedLaunch {
                            HighlightLaunchView(launch: highlightedLaunch)
                                .padding(.top, 30)
                                .onChange(of: scenePhase) { newPhase in
                                    if newPhase == .active {
                                        viewModel.checkStaleLaunch()
                                    }
                                }
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
                .refreshable {
                    viewModel.fetchHighlightLaunch()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
