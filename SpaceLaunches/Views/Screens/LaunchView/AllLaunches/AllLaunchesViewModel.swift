//
//  AllLaunchesViewModel.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 25/09/2023.
//

import Foundation
import Combine

    @MainActor final class AllLaunchesViewModel: ObservableObject {
               
        
        @Published var allLaunches: [Launch] = []
        @Published var searchTerm: String = ""
        @Published var state: FetchState = .good
        
        let service = APIService()
        var subscriptions = Set<AnyCancellable>()

        let limit: Int = 20
        var page: Int = 0

        init() {
            $searchTerm
                .removeDuplicates()
                .dropFirst()
                .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
                .sink { [weak self] term in
                    self?.clear()
                    self?.fetchLaunches(for: term)
            }.store(in: &subscriptions)
        }
        
        func clear() {
            state = .good
            page = 0
            allLaunches = []
        }
        
        func loadMore() {
            fetchLaunches(for: searchTerm)
        }
        
        func fetchLaunches(for searchTerm: String?) {
          
            guard state == .good else {
                return
            }
            
            state = allLaunches.isEmpty ? .empty : .isLoading

            service.fetchLaunches(searchTerm: searchTerm, page: page, limit: limit, type: .all) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let results):
                        for launch in results.results {
                            self?.allLaunches.append(launch)
                        }
                        self?.page += 1
                        self?.state = (results.results.count == self?.limit) ? .good : .loadedAll
                    case .failure(let error):
                        self?.state = .error("Could not load: \(error)")
                        
                    }
                }
            }

        }
    }

