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
        List {
            ForEach(viewModel.upcomingLaunches) { launch in
                LaunchCell(launch: launch)
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
                Color.gray
                
            case .error(let message):
                Text(message)
                    .foregroundColor(.pink)
            }
        }
        .listStyle(.plain)
    }
}

struct UpcomingLaunchesListView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingLaunchesListView()
    }
}
