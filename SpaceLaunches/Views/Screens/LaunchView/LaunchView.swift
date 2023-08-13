//
//  ContentView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 10/08/2023.
//

import SwiftUI
import Kingfisher

struct LaunchView: View {
    
    @StateObject private var viewModel = LaunchViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach (viewModel.searchResults) { launch in
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
                                Label(viewModel.convertDateToString(launch.net).uppercased(), systemImage: "calendar")
                                HStack(spacing: 5) {
                                    Label(viewModel.extractTimeFromDate(launch.net), systemImage: "clock")
                                    Text(viewModel.getUserTimeZone())
                                        .foregroundColor(.secondary)
                                }
                                Label(launch.pad.location.countryCode, systemImage: "location")
                                Label(launch.launchServiceProvider.type?.uppercased() ?? "", systemImage: "list.bullet.rectangle.portrait")
                                
                            }
                            .font(.caption)
                            .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        if let image = UIImage(named: launch.launchServiceProvider.name) {
                            Image(uiImage: image)
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
                
                if viewModel.isLoading {
                    ProgressView()
                        .id(UUID())
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity)
                }
            }
           
        }
        .searchable(text: $viewModel.searchText)
        .task {
            do {
                try await viewModel.getLaunches()
            } catch SLError.invalidURL {
                print("Invalid URL")
            } catch SLError.invalidResponse {
                print("Invalid Response")
            } catch SLError.invalidData {
                print("Invalid Data")
            } catch {
                print("Unexpected Error")
            }
        }
       
        
    }
    
    enum SLError: Error {
        case invalidURL
        case invalidResponse
        case invalidData

    }
    
}
struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
