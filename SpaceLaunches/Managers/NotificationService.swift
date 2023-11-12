//
//  NotificationService.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 29/10/2023.
//

import Foundation
import UserNotifications

class NotificationService {
    
    let service = APIService()
    
    func fetchNotificationLaunches() {
        let dateFormatter = DateFormatter()

        service.fetchLaunches(searchTerm: nil, page: 0, limit: 15, type: .upcoming) {result in
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    print("Notications Fetched")
                    for launch in results.results {
                        let content = UNMutableNotificationContent()
                        content.title = launch.name
                        content.subtitle = launch.launchServiceProvider.name
                        content.body = "24 hours until the launch of \(launch.rocket.configuration.name)"
                        content.sound = UNNotificationSound.default
                        
                        if let targetTime = dateFormatter.date(from: launch.net) {
                            guard let subtractedTime = Calendar.current.date(byAdding: .day, value: -1, to: targetTime) else {
                                print("Could not subtract time")
                                return
                            }
                            
                            let dateComponants = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: subtractedTime)
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponants, repeats: false)
                            let request = UNNotificationRequest(identifier: launch.id, content: content, trigger: trigger)
                            
                            UNUserNotificationCenter.current().add(request) { (error) in
                                if (error != nil) {
                                    print(error?.localizedDescription as Any)
                                }
                            }
                        }
                    }
                    self.getScheduledNotifications()
                case .failure(_):
                    print(print("Error fetching notification launces"))
                }
            }
        }
    }
    
    
    func getAuthorizarionStatus() -> Bool {
        var status = false
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                status = true
            } else {
                status = false
            }
        }
        return status
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notifications Enabled")
                self.fetchNotificationLaunches()
            } else if error != nil {
                print("Notifications Disabled")
            }
        }
    }
    
    func getScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                let content = request.content
                let trigger = request.trigger
                let identifier = request.identifier
                
                let notificationInfo = "Identifier: \(identifier)\nTitle: \(content.title)\nBody: \(content.body)\nTrigger: \(String(describing: trigger))"
                print(notificationInfo)
            }
        }
    }
}
