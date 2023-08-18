//
//  LaunchViewModel.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 13/08/2023.
//

import Foundation

enum ListType: String, CaseIterable {
    case upcoming = "/upcoming"
    case previous = "/previous"
    case all = ""
}

    @MainActor final class LaunchViewModel: ObservableObject {
               
        let menuItems = [ListType.upcoming, ListType.previous, ListType.all]
        var upcomingPage = 0
        var previousPage = 0
        var allPage = 0
        var upcomingFull = false
        var previousFull = false
        var allFull = false
        
        @Published var searchText  = ""
        @Published var events: Events?
        @Published var upcomingLaunches: [Launch] = []
        @Published var previousLaunches: [Launch] = []
        @Published var allLaunches: [Launch] = []
        @Published var launches: [Launch] = []
        @Published var offset = 0
        @Published var isLoading = true
        @Published var isAppending = false
        @Published var limitReached = false
        @Published var selectedMenu: ListType = .upcoming {
            didSet {
                Task {
                    if selectedMenu == .upcoming {
                        if upcomingLaunches.isEmpty {
                            upcomingLaunches = try await getLaunches(for: .upcoming, page: upcomingPage)
                        }
                    } else if selectedMenu == .previous {
                        if previousLaunches.isEmpty {
                            previousLaunches = try await getLaunches(for: .previous, page: previousPage)
                        }
                    } else if selectedMenu == .all {
                        if allLaunches.isEmpty {
                            allLaunches = try await getLaunches(for: .all, page: allPage)
                        }
                    }
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
        
        func getCurrentArrayList() -> [Launch] {
            switch selectedMenu {
            case .upcoming:
                return upcomingLaunches
            case .previous:
                return previousLaunches
            default:
                return allLaunches
            }
        }
        
        func appendPage(List: ListType) {
            Task {
                do {
                    switch List {
                    case .upcoming:
                        upcomingPage += 1
                        upcomingLaunches.append(contentsOf: try await getLaunches(for: .upcoming, page: upcomingPage))
                    case .previous:
                        previousPage += 1
                        previousLaunches.append(contentsOf: try await getLaunches(for: .previous, page: previousPage))
                    default:
                        allPage += 1
                        allLaunches.append(contentsOf: try await getLaunches(for: .all, page: allPage))
                    }
                }
            }
        }
        
        func getLaunchesStart() {
            isLoading = false
            Task {
                do {
                    try Task.checkCancellation()

                    if launches.isEmpty {
                        upcomingLaunches = try await getLaunches(for: .upcoming, page: upcomingPage)
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
        
        func switchList(to listType: ListType) -> [Launch] {
                Task {
                    do {
                        switch listType {
                        case .upcoming:
                            upcomingLaunches = try await getLaunches(for: .upcoming, page: upcomingPage)
                            return upcomingLaunches
                        case .previous:
                            previousLaunches = try await getLaunches(for: .previous, page: previousPage)
                            return previousLaunches
                        default:
                            allLaunches = try await getLaunches(for: .all, page: allPage)
                            return allLaunches
                        }
                    } catch SLError.invalidURL {
                        print("Invalid URL")
                        return upcomingLaunches
                    } catch SLError.invalidResponse {
                        print("Invalid Response")
                        return upcomingLaunches
                    } catch SLError.invalidData {
                        print("Invalid Data")
                        return upcomingLaunches
                    } catch {
                        print("Unexpected Error")
                        return upcomingLaunches

                    }

            }
            return upcomingLaunches
        }
        
        func getLaunches(for listType: ListType, page: Int) async throws -> [Launch] {
            guard !isLoading else {
                print("Already Loading")
                return []
            }
            guard !isAppending else {
                print("Already Appending")
                return []
            }
            
            let endpoint = "https://lldev.thespacedevs.com/2.2.0/launch\(listType.rawValue)/?mode=detailed&limit=\(100)&offset=\(100 * page)"
            print(endpoint)
            
            guard let url = URL(string: endpoint) else {
                throw SLError.invalidURL
            }
            
            if page > 0 {
                isAppending = true
                print("isAppending = true")
            }
            
            if !isAppending {
                isLoading = true
                print("Loading = True")
            }
            
          
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw SLError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let launches = try decoder.decode(Launches.self, from: data)
                
                if isAppending {
                    isAppending = false
                    print("isAppending = \(isAppending)")
                }
                
                if isLoading {
                    isLoading = false
                    print("isLoading = \(isLoading)")
                }
                
                if launches.next == nil {
                    switch selectedMenu {
                    case .upcoming:
                        upcomingFull = true
                    case .previous:
                        previousFull = true
                    default:
                        allFull = true
                    }
                }
                
                return launches.results
                
            } catch {
                if isAppending {
                    isAppending = false
                    print("isAppending = \(isAppending)")
                }
                
                if isLoading {
                    isLoading = false
                    print("isLoading = \(isLoading)")
                }
                
                throw SLError.invalidData
            }

        }
        
        enum SLError: Error {
            case invalidURL
            case invalidResponse
            case invalidData

        }
    }
