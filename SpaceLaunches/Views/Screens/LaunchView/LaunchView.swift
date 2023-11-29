//
//  ContentView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 10/08/2023.
//

import SwiftUI
import Kingfisher

struct LaunchView: View {
    
    @State var searchTerm  = ""
    @State var selectedEntityType = LaunchType.upcoming

    @StateObject private var upcomingLaunchesViewModel = UpcomingLaunchesViewModel()
    @StateObject private var previousLaunchesViewModel = PreviousLaunchesViewModel()
    @StateObject private var allLaunchesViewModel = AllLaunchesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Launch Type", selection: $selectedEntityType) {
                    ForEach(LaunchType.allCases) { type in
                        Text(type.name())
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                switch selectedEntityType {
                case .all:
                    AllLaunchesListView(viewModel: allLaunchesViewModel)
                        .onAppear {
                            allLaunchesViewModel.searchTerm = searchTerm
                        }
                case .previous:
                    PreviousLaunchesListView(viewModel: previousLaunchesViewModel)
                        .onAppear {
                            previousLaunchesViewModel.searchTerm = searchTerm
                        }
                case .upcoming:
                    UpcomingLaunchesListView(viewModel: upcomingLaunchesViewModel)
                        .onAppear {
                            upcomingLaunchesViewModel.searchTerm = searchTerm
                        }
                }
                Spacer()
            }
            .searchable(text: $searchTerm)
            .navigationTitle("Launches")
            .navigationBarTitleDisplayMode(.inline  )
            .toolbar {
                ToolbarItem {
                    NavigationLink(destination: SavedLaunchesView()) {
                        Image(systemName: "heart")
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .onChange(of: searchTerm) { oldValue, newValue in
            switch selectedEntityType {
            case .all:
                allLaunchesViewModel.searchTerm = newValue
            case .upcoming:
                upcomingLaunchesViewModel.searchTerm = newValue
            case .previous:
                previousLaunchesViewModel.searchTerm = newValue
            }
        }
    }
}



struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
            LaunchView()
    }
}
