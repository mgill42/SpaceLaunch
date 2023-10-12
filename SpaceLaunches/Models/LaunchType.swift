//
//  EntityType.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 20/09/2023.
//

import Foundation

enum LaunchType: String, Identifiable, CaseIterable {
    case upcoming
    case previous
    case all

    var id: String {
        self.rawValue
    }
    
    func name() -> String {
        switch self {
        case .upcoming:
            return "Upcoming"
        case .previous:
            return "Previous"
        case .all:
            return "All"

        }
    }
}
