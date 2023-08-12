//
//  ContentView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 10/08/2023.
//

import SwiftUI
import Kingfisher

struct LaunchView: View {
    
    @State private var events: Events?
    @State private var launches: [Launch] = []
    @State private var offset = 0
    @State private var isLoading = false
    @State private var limitReached = false
    
    let maxLimit = 100
    let limit = 20

    var body: some View {
        VStack {
            List {
                ForEach (launches) { launch in
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
                                Label(convertDateToString(launch.windowStart), systemImage: "calendar")
                                Label(launch.pad.location.countryCode, systemImage: "location")
                                Label(launch.launchServiceProvider.type ?? "", systemImage: "list.bullet.rectangle.portrait")

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
                
                if isLoading {
                    ProgressView()
                        .id(UUID())
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity)
                } else if limitReached {
                    EmptyView()
                } else {
                    Color.clear
                        .frame(height: 30)
                        .onAppear {
                            Task {
                                do {
                                    try await getLaunches()
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
                }
            }
        }
    }
    
    func convertDateToString( _ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ssZ"
        guard let date = inputFormatter.date(from: dateString) else { return "Error" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM d yyyy"
        
        return outputFormatter.string(from: date)
    }
    
    
    func getLaunches() async throws {
        guard !isLoading else {
            print("Already Loading")
            return
        }
        
        guard offset <= maxLimit else {
            print("Limit Reached")
            limitReached = true
            return
        }
        
        let endpoint = "https://lldev.thespacedevs.com/2.2.0/launch/upcoming?limit=\(limit)?&offset=\(offset)"
        print(endpoint)
        
        guard let url = URL(string: endpoint) else {
            throw SLError.invalidURL
        }
        
        isLoading = true
        print("Loading = True")
              
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SLError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let Launches = try decoder.decode(Launches.self, from: data)
            self.launches.append(contentsOf: Launches.results)
        } catch {
            throw SLError.invalidData
        }
        
        offset += limit
        isLoading = false
        print("Loading = False")

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
