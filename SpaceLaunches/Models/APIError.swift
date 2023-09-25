//
//  APIError.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 20/09/2023.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    
    case badURL
    case urlSession(URLError?)
    case badResponse(Int)
    case decodingError(DecodingError?)
    case unknown
    
    var description: String {
        switch self {
        case .badURL:
            return "badURL"
        case .urlSession(let urlError):
            return "urlSession error: \(urlError.debugDescription)"
        case .badResponse(let statusCode):
            return "bad response with status code: \(statusCode)"
        case .decodingError(let decodingError):
            return "decoding error: \(String(describing: decodingError))"
        case .unknown:
            return "unknown description"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .badURL, .unknown:
            return "something went wrong"
        case .urlSession(let urlError):
            return urlError?.localizedDescription ?? "something went wrong"
        case .badResponse(_):
            return ("something went wrong")
        case .decodingError(let decodingError):
            return decodingError?.localizedDescription ?? "something went wrong"
        }
    }
}
