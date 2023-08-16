//
//  LaunchViewModel.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 13/08/2023.
//

import Foundation
    
    @MainActor final class LaunchViewModel: ObservableObject {
        
        enum ListType: String {
            case upcoming = "/upcoming"
            case previous = "/previous"
            case all = ""
        }
   
        let menuItems = ["Upcoming", "Previous", "All"]
        var upcomingLimit = 100
        var previousLimit = 100
        var allLimit = 100
        @Published var searchText  = ""
        @Published var events: Events?
        @Published var upcomingLaunches: [Launch] = []
        @Published var previousLaunches: [Launch] = []
        @Published var allLaunches: [Launch] = []
        @Published var launches: [Launch] = []
        @Published var offset = 0
        @Published var isLoading = false
        @Published var limitReached = false
        @Published var selectedMenu = "Upcoming" {
            didSet {
                if selectedMenu == menuItems[0] {
                    if upcomingLaunches.isEmpty {
                        switchList(to: .upcoming)
                    }
                    launches = upcomingLaunches
                } else if selectedMenu == menuItems[1] {
                    if previousLaunches.isEmpty {
                        switchList(to: .previous)
                    }
                    launches = previousLaunches
                } else if selectedMenu == menuItems[2] {
                    if allLaunches.isEmpty {
                        switchList(to: .all)
                    }
                    launches = allLaunches
                 }
            }
        }
                
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
        
        func getLaunchesStart() {
            isLoading = false
            Task {
                do {
                    try Task.checkCancellation()

                    if launches.isEmpty {
                        upcomingLaunches = try await getLaunches(for: .upcoming, limit: upcomingLimit)
                        launches = upcomingLaunches
                    }
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
        
        func switchList(to listType: ListType) {
                Task {
                    do {
                        switch listType {
                        case .upcoming:
                            upcomingLaunches = try await getLaunches(for: .upcoming, limit: upcomingLimit)
                            launches = upcomingLaunches
                        case .previous:
                            previousLaunches = try await getLaunches(for: .previous, limit: previousLimit)
                            launches = previousLaunches
                        default:
                            allLaunches = try await getLaunches(for: .all, limit: allLimit)
                            launches = allLaunches
                        }
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
        
      
        
        func getLaunches(for listType: ListType, limit: Int) async throws -> [Launch] {
            guard !isLoading else {
                print("Already Loading")
                return []
            }
            
            let endpoint = "https://lldev.thespacedevs.com/2.2.0/launch\(listType.rawValue)/?mode=detailed&limit=\(limit)"
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
    

