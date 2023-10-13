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
    
    static func example() -> Event {
        Event(id: 403, url: "https://ll.thespacedevs.com/2.2.0/event/403/", slug: "lucy-trojan-asteroids-617-patroclus-menoetius-flyb", name: "Lucy Trojan Asteroids (617) Patroclus & Menoetius Flyby", updates: [], type: EventType(id: 23, name: "Flyby"), description: "Flyby of the Trojan binary asteroid pair (617) Patroclus and Menoetius by NASA's Lucy mission.", webcastLive: false, location: "(617) Patroclus & Menoetius", newsUrl: "http://lucy.swri.edu/timeline.html", videoUrl: nil, featureImage: "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/event_images/lucy_trojan_ast_image_20210930113156.jpg", date: "2023-10-13T18:00:00Z", datePrecision: nil)
    }
    
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
