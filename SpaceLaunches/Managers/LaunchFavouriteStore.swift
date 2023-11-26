//  LaunchStore.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 16/11/2023.
//

import Foundation

class LaunchFavouriteStore {
    
    static let shared = LaunchFavouriteStore()
    
    var favouriteLaunches: [Launch] = []
    
    func load() throws {
        guard let data = UserDefaults.shared.value(forKey: UserDefaults.launchKey) as? Data else {
            return
        }
        do {
            let decodedFavourites = try JSONDecoder().decode([Launch].self, from: data)
            favouriteLaunches = decodedFavourites
        } catch {
            throw error
        }
    }
    
    
    func save(launch: Launch) throws {
        
        favouriteLaunches.append(launch)
        do {
            let data = try JSONEncoder().encode(favouriteLaunches)
            UserDefaults.shared.set(data, forKey: UserDefaults.launchKey)
        } catch {
            throw error
        }
    }

    
    func delete(launch: Launch) throws {
        favouriteLaunches.removeAll { $0.id == launch.id }
        do {
            let data = try JSONEncoder().encode(favouriteLaunches)
            UserDefaults.shared.set(data, forKey: UserDefaults.launchKey)
        } catch {
            throw error
        }
        
    }
    
    
    func checkIfFavourite(launch: Launch) -> Bool {
        if favouriteLaunches.contains(where: { $0.id == launch.id }) {
            return true
        } else {
            return false
        }
    }
}


