//
//  SelectFavouriteLaunch.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 28/11/2023.
//

import Foundation
import AppIntents
import SwiftUI

struct SelectFavouriteLaunch: AppIntent, WidgetConfigurationIntent, CustomIntentMigratedAppIntent {
    static var intentClassName = "SelectFavouriteLaunchIntent"
    static var title: LocalizedStringResource = "Select Favorite Launch"
    static var description = IntentDescription("Choose a launch to watch")
    
    @Parameter(title: "Launch", optionsProvider: LaunchOptionsProvider())
    var launch: LaunchEntity?
    
    struct LaunchOptionsProvider: DynamicOptionsProvider {
        func results() async throws -> [LaunchEntity] {
            try LaunchFavouriteStore.shared.load()
            return LaunchFavouriteStore.shared.favouriteLaunches.map {
                LaunchEntity(id: $0.id, name: $0.name, net: $0.net, launchServiceProvier: $0.launchServiceProvider, image: $0.image, pad: $0.pad)
            }
        }
        
        func defaultResult() async -> LaunchEntity? {
            return LaunchFavouriteStore.shared.favouriteLaunches.map {
                LaunchEntity(id: $0.id, name: $0.name, net: $0.net, launchServiceProvier: $0.launchServiceProvider, image: $0.image, pad: $0.pad)
            }.first      
        }
    }
}

struct LaunchEntity: AppEntity {
    
    var id: String
    var name: String
    var net: String
    var launchServiceProvier: LaunchServiceProvider
    var image: String?
    var pad: Pad?
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(stringLiteral: "Launch")
    static var defaultQuery = LaunchQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    static let example = LaunchEntity(id: Launch.example().id, name: Launch.example().name, net: Launch.example().net, launchServiceProvier: Launch.example().launchServiceProvider, pad: Launch.example().pad)
}

struct LaunchQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [LaunchEntity] {
        try LaunchFavouriteStore.shared.load()
        
        return LaunchFavouriteStore.shared.favouriteLaunches.map {
            LaunchEntity(id: $0.id, name: $0.name, net: $0.net, launchServiceProvier: $0.launchServiceProvider, image: $0.image, pad: $0.pad)
        }
        .filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [LaunchEntity] {
        try LaunchFavouriteStore.shared.load()
        return LaunchFavouriteStore.shared.favouriteLaunches.map {
            LaunchEntity(id: $0.id, name: $0.name, net: $0.net, launchServiceProvier: $0.launchServiceProvider, image: $0.image, pad: $0.pad)
        }
    }
    
    func defaultResult() async -> LaunchEntity? {
        return LaunchFavouriteStore.shared.favouriteLaunches.map {
            LaunchEntity(id: $0.id, name: $0.name, net: $0.net, launchServiceProvier: $0.launchServiceProvider, image: $0.image, pad: $0.pad)
        }.first
    }
}

