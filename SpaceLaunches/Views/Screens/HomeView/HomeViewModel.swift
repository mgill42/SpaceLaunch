//
//  HighlightLaunchViewModel.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 26/09/2023.
//

import Foundation
import UserNotifications

@MainActor final class HomeViewModel: ObservableObject {
    
    @Published var highLightedLaunch: Launch?
    @Published var state: FetchState = .good
    
    var notificationLaunches = [Launch]()
    
    let dateFormatter = DateFormatter()
    let service = APIService()
    
    func fetchHighlightLaunch() {
        
        guard state == .good else {
            return
        }
        
        state = highLightedLaunch == nil ? .isEmpty : .isLoading

        service.fetchHighlightLaunch { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.highLightedLaunch = success
                    self.state = .loadedAll
                case .failure(let failure):
                    self.state = .error("ERROR: \(failure)")
                }
            }
        }
    }
}
