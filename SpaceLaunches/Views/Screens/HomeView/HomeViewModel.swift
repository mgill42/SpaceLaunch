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
    
    let dateFormatter = DateFormatter()

    
    let service = APIService()
    
    func fetchHighlightLaunch() {
      
        guard state == .good else {
            return
        }
        
        state = highLightedLaunch == nil ? .empty : .isLoading
        
        service.fetchLaunches(searchTerm: nil, page: 0, limit: 5, type: .upcoming) {result in
            self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self.highLightedLaunch = results.results.first(where: {
                  
                        if let date = self.dateFormatter.date(from: $0.net) {
                            return date > Date()
                        } else {
                            return true
                        }
                        
                    })
                    self.state = .loadedAll
                case .failure(let error):
                    self.state = .error("Could not load: \(error)")
                }
            }
        }
    }
    
}
