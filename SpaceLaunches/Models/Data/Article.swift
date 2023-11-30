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
}
