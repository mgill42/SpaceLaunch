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
        
        service.fetchLaunches(searchTerm: nil, page: 0, limit: 10, type: .upcoming) {result in
            self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self.notificationLaunches = results.results
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
                // Add upcoming launches to NotificationCenter
           //     self.applyNotifications(launches: self.notificationLaunches)
            }
        }
    }
    
//    func applyNotifications(launches: [Launch]) {
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        let calandar = Calendar.current
//
//        for launch in launches {
//            let content = UNMutableNotificationContent()
//            content.title = launch.name
//            content.subtitle = launch.launchServiceProvider.name
//            content.sound = UNNotificationSound.default
//            
//            if let targetTime = dateFormatter.date(from: launch.net) {
//                guard let subtractedTime = calandar.date(byAdding: .minute, value: -10, to: targetTime) else {
//                    print("Could not subtract time")
//                    return
//                }
//                let dateComponants = calandar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: subtractedTime)
//                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponants, repeats: false)
//                
//                let request = UNNotificationRequest(identifier: launch.id, content: content, trigger: trigger)
//                
//                UNUserNotificationCenter.current().add(request) { (error) in
//                    if (error != nil) {
//                        print(error?.localizedDescription as Any)
//                    }
//                }
//            }
//        }
//    }
}
