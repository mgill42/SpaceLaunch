//
//  Launch.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 11/08/2023.
//

import Foundation
import CoreLocation


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
    let rocket: Rocket
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
           probability: 70, rocket: Rocket(id: 2737, configuration: Rocket.Configuration(id: 2737, url: "https://lldev.thespacedevs.com/2.2.0/config/launcher/8/", name: "Atlas V 531", active: true, reusable: false, description: "Atlas V with 5m Fairing, 3 SRB, 1 Centaur upper stage engine.", family: "Atlas", fullName: "Atlas V 531", length: 60.0, diameter: 3.8, maidenFlight: "2010-08-14", launchCost: "140000000", launchMass: 479, leoCapacity: 15530, gtoCapacity: 7450, imageUrl: "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/launcher_images/atlas2520v2520531_image_20190222030726.jpeg", totalLaunchCount: 5, consecutiveSuccessfulLaunches: 5, successfulLaunches: 5, failedLaunches: 0, pendingLaunches: 0, attemptedLandings: 0, successfulLandings: 0, failedLandings: 0, consecutiveSuccessfulLandings: 0)),
           weatherConcerns: nil,
           launchServiceProvider: LaunchServiceProvider(id: 124, url: "https://lldev.thespacedevs.com/2.2.0/agencies/124/", name: "United Launch Alliance", type: "Commercial", logoUrl: "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/logo/united2520launch2520alliance_logo_20210412195953.png", description: "United Launch Alliance (ULA) is a joint venture of Lockheed Martin Space Systems and Boeing Defense, Space & Security. ULA was formed in December 2006 by combining the teams at these companies which provide spacecraft launch services to the government of the United States. ULA launches from both coasts of the US. They launch their Atlas V vehicle from LC-41 in Cape Canaveral and LC-3E at Vandeberg. Their Delta IV launches from LC-37 at Cape Canaveral and LC-6 at Vandenberg."),
           mission: Mission(id: 6090, name: "NROL-91", description: "Classified payload for the US National Reconnaissance Office (NRO).", type: "Government/Top Secret", orbit: Orbit(id: 1, name: "Low Earth Orbit", abbrev: "LEO"), agencies: []),
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
    
    var latitudeDeg: Double {
        if let latitude = latitude {
            return Double(latitude) ?? 0.0
        } else {
            return 0.0
        }
    }
    
    var longitudeDeg: Double {
        if let longitude = longitude {
            return Double(longitude) ?? 0.0
        } else {
            return 0.0
        }
    }
    
    var launchLocation: LaunchLocation {
        LaunchLocation(coordinate: CLLocationCoordinate2D(latitude: Double(latitude ?? "0.0") ?? 0.0,
                                                          longitude: Double(longitude ?? "0.0") ?? 0.0))
    }
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
    let description: String
}

struct Rocket: Codable, Identifiable {
    let id: Int
    let configuration: Configuration
    
    struct Configuration: Codable, Identifiable {
        let id: Int
        let url: String
        let name: String
        let active: Bool
        let reusable: Bool
        let description: String
        let family: String
        let fullName: String
        let length: Double?
        let diameter: Double?
        let maidenFlight: String?
        let launchCost: String?
        let launchMass: Double?
        let leoCapacity: Int?
        let gtoCapacity: Int?
        let imageUrl: String?
        let totalLaunchCount: Int
        let consecutiveSuccessfulLaunches: Int
        let successfulLaunches: Int
        let failedLaunches: Int
        let pendingLaunches: Int
        let attemptedLandings: Int
        let successfulLandings: Int
        let failedLandings: Int
        let consecutiveSuccessfulLandings: Int
        
        
    }
}

struct Mission: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let type: String
    let orbit: Orbit
    let agencies: [Agency]

}

struct Orbit: Codable, Identifiable {
    let id: Int
    let name: String
    let abbrev: String
}


