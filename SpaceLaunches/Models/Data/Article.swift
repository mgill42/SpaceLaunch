//
//  Article.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 30/11/2023.
//

import Foundation

struct Articles: Codable {
    let count: Int
    let next: String?
    let previous: String?
    var results: [Article]
}

struct Article: Codable, Identifiable {
    let id: Int
    let title: String
    let url: String
    let imageUrl: String
    let newsSite: String
    let summary: String
    let publishedAt: String
    let updatedAt: String?
    let featured: Bool
    
    static func example() -> Article {
        return Article(id: 21691,
                       title: "Hubble glitch renews talk about private servicing mission",
                       url: "https://spacenews.com/hubble-glitch-renews-talk-about-private-servicing-mission/",
                       imageUrl: "https://spacenews.com/wp-content/uploads/2021/07/hubble-sts125release-300x169.jpg",
                       newsSite: "SpaceNews",
                       summary: "A problem with the Hubble Space Telescope has renewed discussion about whether and how NASA might approve a private mission to reboost and potentially repair the spacecraft.",
                       publishedAt: "2023-12-02T23:25:32Z",
                       updatedAt: "2023-12-03T08:12:13.217000Z",
                       featured: false)
    }
}
