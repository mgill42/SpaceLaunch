//
//  ContentView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 10/08/2023.
//

import SwiftUI
import Kingfisher

struct LaunchView: View {
    
    enum SLError: Error {
        case invalidURL
        case invalidResponse
        case invalidData

    }
    
    @StateObject private var viewModel = LaunchViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !viewModel.isLoading {
                    List {
                        ForEach (viewModel.launches) { launch in
                            LaunchCell(launch: launch, viewModel: viewModel)
                        }
                        ProgressView()
                            .id(UUID())
                            .progressViewStyle(.circular)
                            .frame(maxWidth: .infinity)
                    }
                } else {
                    LoadingView()
                }
            }
            .navigationTitle("Launches")
            .toolbar{
                ToolbarItem(placement: .principal) {
                    LaunchPicker(viewModel: viewModel)
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .task {
            viewModel.getLaunchesStart()
        }
     
    }
    
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(alignment: .center) {
            ProgressView()
                .id(UUID())
                .progressViewStyle(.circular)
                .frame(maxWidth: .infinity)
            Text("Fetching Launches")
        }
    }
}

struct LaunchPicker: View {
    @ObservedObject var viewModel: LaunchViewModel
    var body: some View {
        
        Picker(selection: $viewModel.selectedMenu, label: Text("Select List")) {
            ForEach(viewModel.menuItems, id: \.self) {
                Text($0)
            }
        }
        .disabled(viewModel.isLoading ? true : false)
        .pickerStyle(.segmented)
        .padding(.horizontal, 50)
    }
}

struct LaunchCell: View {
    
    let launch: Launch
    let viewModel: LaunchViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(launch.name)
                    .bold()
                    .font(.subheadline)
                Text(launch.launchServiceProvider.name)
                    .font(.caption)
                    .padding(.bottom, 8)
                    .foregroundColor(.secondary)
                VStack(alignment: .leading, spacing: 5) {
                    Label(launch.status.name.uppercased(), systemImage: launch.status.id == 3 || launch.status.id == 1 ? "checkmark.circle" : "exclamationmark.triangle")
                        .foregroundColor(launch.status.id == 3 || launch.status.id == 1 ? .green : .primary)
                    Label(viewModel.convertDateToString(launch.net).uppercased(), systemImage: "calendar")
                    HStack(spacing: 5) {
                        Label(viewModel.extractTimeFromDate(launch.net), systemImage: "clock")
                        Text(viewModel.getUserTimeZone())
                            .foregroundColor(.secondary)
                    }
                    Label(launch.pad.location.countryCode, systemImage: "location")
                }
                .font(.caption)
                .foregroundColor(.primary)
            }
            
            Spacer()
            
            if let imageUrl = launch.launchServiceProvider.logoUrl {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                    }
            } else {
                Image("Placeholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                    }
            }
        }
    }
}
