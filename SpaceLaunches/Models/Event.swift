//
//  File.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 10/08/2023.
//

import Foundation

struct Events: Codable {
    let count: Int
    let next: String
    var previous: String?
    let results: [Event]
    
}

struct Event: Codable, Identifiable {
    let id: Int
    let url: String?
    let slug: String?
    let name: String
    let updates: [Update]?
    let type: EventType?
    let description: String?
    let webcastLive: Bool?
    let location: String?
    let newsUrl: String?
    let videoUrl: String?
    let featureImage: String?
    let date: String?
    let datePrecision: DatePrecision?
    
}

struct DatePrecision: Codable, Identifiable {
    let id: Int
    let name: String
    let abbrev: String
    let description: String
}

struct Update: Codable, Identifiable {
    let id: Int
    let profileImage: String
    let comment: String
    let infoUrl: String
    let createdBy: String
    let createdOn: String
}

struct EventType: Codable, Identifiable {
    let id: Int
    let name: String
}
