//
//  LaunchViewModel.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 13/08/2023.
//

import Foundation

extension LaunchView {
    
    @MainActor final class LaunchViewModel: ObservableObject {
        
        @Published var searchText  = ""
        
        @Published var events: Events?
        @Published var launches: [Launch] = []
        @Published var offset = 0
        @Published var isLoading = false
        @Published var limitReached = false
        
        let limit = 80
        
        var searchResults: [Launch] {
            if searchText.isEmpty {
                return launches
            } else {
                return launches.filter { $0.name.contains(searchText) }
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
        
        func getUserTimeZone() -> String {
            let userTimeZone = TimeZone.current

            if let abbreviation = userTimeZone.abbreviation() {
                return abbreviation
            } else {
                return ""
            }
        }
        
        func extractTimeFromDate( _ dateString: String) -> String {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ssZ"
            guard let date = inputFormatter.date(from: dateString) else { return "Error" }
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "h:mm a"

            return outputFormatter.string(from: date)
    
        }
        
        func getLaunches() async throws {
            guard !isLoading else {
                print("Already Loading")
                return
            }
      
            
            let endpoint = "https://lldev.thespacedevs.com/2.2.0/launch/upcoming?limit=\(limit)"
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
                launches.append(contentsOf: Launches.results)
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
    
}
