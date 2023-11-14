//
//  SpaceLaunchesApp.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 10/08/2023.
//

import SwiftUI

@main
struct SpaceLaunchesApp: App {
    
    let notificationService = NotificationService()
    
    init() {
        notificationService.requestPermission()
    }
 
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
        }
    }
}
