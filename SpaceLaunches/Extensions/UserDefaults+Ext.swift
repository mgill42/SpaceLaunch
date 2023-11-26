//
//  UserDefaults+Ext.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 25/11/2023.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        UserDefaults(suiteName: "group.me.gill.mahaveer.SpaceLaunches")!
    }
    
    static let launchKey = "favouriteLaunches"

}

enum UserDefaultsError: Error {
    case retrieval
}

