//
//  HighlightLaunchViewModel.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 26/09/2023.
//

import Foundation

@MainActor final class HomeViewModel: ObservableObject {
    
    @Published var highLightedLaunch: Launch?
    @Published var state: FetchState = .good
    
    let service = APIService()
    
    func fetchHighlightLaunch() {
      
        guard state == .good else {
            return
        }
        
        state = .isLoading
        
        service.fetchLaunches(searchTerm: nil, page: 1, limit: 1, type: .upcoming) {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self.highLightedLaunch = results.results.first
                    self.state = .loadedAll
                case .failure(let error):
                    self.state = .error("Could not load: \(error)")
                }
            }
        }
    }
    
}
