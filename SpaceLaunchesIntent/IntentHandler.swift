//
//  IntentHandler.swift
//  SpaceLaunchesIntent
//
//  Created by Mahaveer Gill on 25/11/2023.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        return self
    }
}

extension IntentHandler: SelectFavouriteLaunchIntentHandling {

    func provideLaunchOptionsCollection(for intent: SelectFavouriteLaunchIntent) async throws -> INObjectCollection<NSString> {
        guard let repos = UserDefaults.shared.value(forKey: UserDefaults.launchKey) as? [String] else {
            throw UserDefaultsError.retrieval
        }
        return INObjectCollection(items: repos as [NSString])
    }
    
    func defaultLaunch(for intent: SelectFavouriteLaunchIntent) -> String? {
        return "6"
    }
}
