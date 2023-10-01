//
//  Launch.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 11/08/2023.
//

import Foundation


struct Launches: Codable {
    let count: Int
    let next: String?
    let previous: String?
    var results: [Launch]
}

struct Launch: Codable, Identifiable {
    
    let id: String
    let url: String
    let slug: String
    let name: String
    let status: Status
    let lastUpdated: String
    let net: String
    let netPrecision: NetPrecision?
    let windowEnd: String
    let windowStart: String
    let probability: Int?
    let weatherConcerns: String?
    let launchServiceProvider: LaunchServiceProvider
    let mission: Mission?
    let pad: Pad?
    let image: String?
    
    static func example() -> Launch {
        
    Launch(id: "558c199e-4cfb-4914-b5d3-452b63d492bf",
           url: "https://lldev.thespacedevs.com/2.2.0/launch/558c199e-4cfb-4914-b5d3-452b63d492bf/",
           slug: "delta-iv-heavy-nrol-91",
           name: "Delta IV Heavy | NROL-91",
           status: Status(id: 3, name: "Launch Successful", abbrev: "Success", description: "The launch vehicle successfully inserted its payload(s) into the target orbit(s)."),
           lastUpdated: "2023-06-14T17:25:51Z",
           net: "2022-09-24T22:25:30Z",
           netPrecision: nil,
           windowEnd: "2022-09-24T23:12:00Z",
           windowStart: "2022-09-24T20:50:00Z",
           probability: 70,
           weatherConcerns: nil,
           launchServiceProvider: LaunchServiceProvider(id: 124, url: "https://lldev.thespacedevs.com/2.2.0/agencies/124/", name: "United Launch Alliance", type: "Commercial", logoUrl: "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/logo/united2520launch2520alliance_logo_20210412195953.png"),
           mission: Mission(id: 6090, name: "NROL-91", description: "Classified payload for the US National Reconnaissance Office (NRO).", type: "Government/Top Secret", agencies: []),
           pad: Pad(id: 11, url: "https://lldev.thespacedevs.com/2.2.0/pad/11/", name: "Space Launch Complex 6", latitude: "34.5815", longitude: "-120.6262", location: Location(id: 11, url: "https://lldev.thespacedevs.com/2.2.0/location/11/", name: "Vandenberg SFB, CA, USA", countryCode: "USA", mapImage: "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/launch_images/location_11_20200803142416.jpg", timezoneName: "America/Los_Angeles")),
           image: "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/launcher_images/delta_iv_heavy_image_20210426103838.jpg")
    }
  
}

struct NetPrecision: Codable, Identifiable {
    let id: Int
    let abbrev: String
}

struct Pad: Codable, Identifiable {
    let id: Int
    let url: String
    let name: String
    let latitude: String?
    let longitude: String?
    let location: Location
}

struct Location: Codable, Identifiable {
    let id: Int
    let url: String
    let name: String
    let countryCode: String
    let mapImage: String
    let timezoneName: String

}

struct Agency: Codable, Identifiable {
    let id: Int
    let url: String
    let name: String
//    let featured: Bool
//    let type: String
//    let countryCode: String
//    let abbrev: String
//    let description: String?
//    let spacecraft: String
//    let totalLaunchCount: Int?
//    let consecutiveSuccessfulLaunches: Int?
//    let successfulLaunches: Int?
//    let failedLaunches: Int?
//    let pendingLaunches: Int?
//    let failedLandings: Int?
//    let attemptedLandings: Int?
    let infoUrl: String?
    let wikiUrl: String?
    let logoUrl: String?
    let imageUrl: String?
    let nationUrl: String?
}

struct Status: Codable, Identifiable {
    let id: Int
    let name: String
    let abbrev: String
    let description: String
}

struct LaunchServiceProvider: Codable, Identifiable {
    let id: Int
    let url: String
    let name: String
    let type: String?
    let logoUrl: String?
}

struct Rocket: Codable, Identifiable {
    let id: Int
    let url: String
    let name: String
    let family: String
    let fullName: String
    let variant: String
}

struct Mission: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let type: String
//    let orbit: Orbit
    let agencies: [Agency]

}

struct Orbit: Codable, Identifiable {
    let id: Int
    let name: String
    let abbrev: String
}


