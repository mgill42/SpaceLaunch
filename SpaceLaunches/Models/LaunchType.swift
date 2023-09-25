//
//  EntityType.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 20/09/2023.
//

import Foundation

enum LaunchType: String, Identifiable, CaseIterable {
    case all
    case previous
    case upcoming
    
    var id: String {
        self.rawValue
    }
    
    func name() -> String {
        switch self {
        case .all:
            return "All"
        case .previous:
            return "Previous"
        case .upcoming:
            return "Upcoming"
        }
    }
}
