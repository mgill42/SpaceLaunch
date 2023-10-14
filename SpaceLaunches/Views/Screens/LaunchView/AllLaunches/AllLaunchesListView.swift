//
//  AllLaunchesListView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 25/09/2023.
//

import SwiftUI

struct AllLaunchesListView: View {
    @ObservedObject var viewModel = AllLaunchesViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.allLaunches) { launch in
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
            case .error(let message):
                Text(message)
                    .foregroundColor(.pink)
            case .empty:
                LaunchLoadingView()
                    .listRowSeparator(.hidden)
                    .padding(.top, 150) 
            }
        }
        .listStyle(.plain)
    }
}

struct AllLaunchesListView_Previews: PreviewProvider {
    static var previews: some View {
        AllLaunchesListView()
    }
}
