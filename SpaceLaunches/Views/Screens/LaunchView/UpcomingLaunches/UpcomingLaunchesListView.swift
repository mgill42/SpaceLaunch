//
//  UpcomingLaunchesListView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 20/09/2023.
//

import SwiftUI

struct UpcomingLaunchesListView: View {
    
    @ObservedObject var viewModel = UpcomingLaunchesViewModel()
    
    var body: some View {
        GeometryReader { geo in
            List {
                ForEach(viewModel.upcomingLaunches) { launch in
                    NavigationLink(destination: LaunchDetailView(launch: launch)) {
                        LaunchCell(launch: launch)
                    }
                    .listRowSeparator(.hidden)
                }
                
                switch viewModel.state {
                case .good:
                    Color.clear
                        .onAppear {
                            viewModel.loadMore()
                        }
                case .isLoading:
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity)
                        .id(UUID())
                case .loadedAll:
                    EmptyView()
                case .error:
                    ErrorPlaceholderView()
                        .frame(height: geo.size.height / 1.1)
                        .frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                case .isEmpty:
                    VStack(alignment: .center) {
                        LaunchLoadingView()
                            .frame(height: geo.size.height / 1.1)
                            .listRowSeparator(.hidden)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

struct UpcomingLaunchesListView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingLaunchesListView()
    }
}
