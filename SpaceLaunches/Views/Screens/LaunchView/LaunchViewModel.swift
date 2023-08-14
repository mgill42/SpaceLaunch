//
//  LaunchViewModel.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 13/08/2023.
//

import Foundation

extension LaunchView {
    
    @MainActor final class LaunchViewModel: ObservableObject {
        
        let menuItems = ["Upcoming", "Previous", "All"]
        
        @Published var selectedMenu = "Upcoming" {
            didSet {
                if selectedMenu == "Upcoming" {
                    if upcomingLaunches.isEmpty {
                        Task {
                            do {
                                upcomingLaunches = try await getLaunches(for: "upcoming")
                                launches = upcomingLaunches
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
                    launches = upcomingLaunches
                } else if selectedMenu == "Previous" {
                    if previousLaunches.isEmpty {
                        Task {
                            do {
                                previousLaunches = try await getLaunches(for: "previous")
                                launches = previousLaunches

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
                    launches = previousLaunches
                }
            }
        }
        @Published var searchText  = ""
        @Published var events: Events?
        @Published var upcomingLaunches: [Launch] = []
        @Published var previousLaunches: [Launch] = []
        @Published var allLaunches: [Launch] = []
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
        
        func getLaunches(for launch: String) async throws -> [Launch] {
            guard !isLoading else {
                print("Already Loading")
                return []
            }
            let endpoint = "https://lldev.thespacedevs.com/2.2.0/launch/\(launch)/?mode=detailed"
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
                
                let launches = try decoder.decode(Launches.self, from: data)
                
                isLoading = false
                print("Loading = False")
                return launches.results
                
            } catch {
                isLoading = false
                print("Loading = False")
                throw SLError.invalidData
             
            }
        }
        
        enum SLError: Error {
            case invalidURL
            case invalidResponse
            case invalidData

        }
        
    }
    
}
