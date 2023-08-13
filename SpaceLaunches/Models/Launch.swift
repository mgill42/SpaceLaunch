//
//  Launch.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 11/08/2023.
//

import Foundation

struct Launches: Codable {
    let count: Int
    let next: String
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
    let netPrecision: NetPrecision
    let windowEnd: String
    let windowStart: String
    let probability: Int?
    let weatherConcerns: String?
    let launchServiceProvider: LaunchServiceProvider
    let mission: Mission?
    let pad: Pad
  
}

struct NetPrecision: Codable, Identifiable {
    let id: Int
    let abbrev: String
}

struct Pad: Codable, Identifiable {
    let id: Int
    let url: String
    let name: String
    let latitude: String
    let longitude: String
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
    let orbit: Orbit
    let agencies: [Agency]

}

struct Orbit: Codable, Identifiable {
    let id: Int
    let name: String
    let abbrev: String
}

