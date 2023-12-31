//
//  PreviousLaunchesListView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 25/09/2023.
//

import SwiftUI

struct PreviousLaunchesListView: View {
    
    @ObservedObject var viewModel = PreviousLaunchesViewModel()
    
    var body: some View {
        GeometryReader { geo in
            List {
                ForEach(viewModel.previousLaunches) { launch in
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
            .refreshable {
                viewModel.loadMore()
            }
        }
    }
}

struct PreviousLaunchesListView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousLaunchesListView()
    }
}
