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
        List {
            ForEach(viewModel.previousLaunches) { launch in
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

struct PreviousLaunchesListView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousLaunchesListView()
    }
}
