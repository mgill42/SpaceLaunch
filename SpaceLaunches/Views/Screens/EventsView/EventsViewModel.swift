//
//  EventsViewModel.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 14/10/2023.
//

import Foundation

@MainActor final class EventsViewModel: ObservableObject {
    
    let service = APIService()
    @Published var events: [Event] = []
    @Published var state: FetchState = .good
    
    
    func fetchEvents() {
        
        guard state == .good || state == .error else {
            return
        }
        
        state = events.isEmpty ? .isEmpty : .isLoading

        service.fetchEvents { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    for event in results.results {
                        self.events.append(event)
                    }
                    self.state = .loadedAll
                case .failure(_):
                    self.state = .error
                }
            }
        }
    }
}
