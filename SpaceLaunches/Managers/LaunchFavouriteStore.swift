//Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
//  LaunchStore.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 16/11/2023.
//

import Foundation

class LaunchFavouriteStore: ObservableObject {
    @Published var favouriteLaunches: [Launch] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
        .appendingPathComponent("launchFavourites.data")
        }
    
    func load() async throws {
        do {
            let fileURL = try Self.fileURL()
            let data = try Data(contentsOf: fileURL)
            let favouriteLaunches = try JSONDecoder().decode([Launch].self, from: data)

            DispatchQueue.main.async {
                self.favouriteLaunches = favouriteLaunches
                }
            } catch {
                throw error
            }
      }
    
    func save(launch: Launch) async throws {
        Task {
            let outfile = try Self.fileURL()
            do {
                var favouritesArray = try JSONDecoder().decode([Launch].self, from: Data(contentsOf: outfile))
                favouritesArray.append(launch)
                let data = try JSONEncoder().encode(favouritesArray)
                try data.write(to: outfile)
            } catch {
                var favouritesArray: [Launch] = []
                favouritesArray.append(launch)
                let data = try JSONEncoder().encode(favouritesArray)
                try data.write(to: outfile)
            }
        }
    }
    
    func delete(launch: Launch) async throws {
        Task {
            let outfile = try Self.fileURL()
            do {
                var favouritesArray = try JSONDecoder().decode([Launch].self, from: Data(contentsOf: outfile))
                favouritesArray.removeAll { $0.id == launch.id }
                let data = try JSONEncoder().encode(favouritesArray)
                try data.write(to: outfile)
            }
        }
    }
    
    func checkIfFavourite(launch: Launch) -> Bool {
        do {
            let outfile         = try Self.fileURL()
            let favouritesArray = try JSONDecoder().decode([Launch].self, from: Data(contentsOf: outfile))
            if favouritesArray.contains(where: { $0.id == launch.id}) {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}


