//
//  APIService.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 20/09/2023.
//

import Foundation

class APIService {
    
    func fetchLaunches(searchTerm: String?, page: Int, limit: Int, type: LaunchType, completion: @escaping(Result<Launches,APIError>) -> Void) {
        let url = createURL(for: searchTerm, type: type, page: page, limit: limit)
        fetch(type: Launches.self, url: url,completion: completion)
    }
    
//    func fetchLatestLaunch(completion: @escaping(Result<Launches,APIError>) -> Void) {
//        let url = createURL(for: nil, type: .upcoming, page: 1, limit: 1)
//        fetch(type: Launches.self, url: url, completion: completion)
//    }

    func fetch<T: Decodable>(type: T.Type, url: URL?, completion: @escaping(Result<T,APIError>) -> Void) {
        
        guard let url = url else {
            let error = APIError.badURL
            completion(Result.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error as? URLError {
                completion(Result.failure(APIError.urlSession(error)))
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIError.badResponse(response.statusCode)))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try decoder.decode(type.self, from: data)
                    completion(Result.success(result))
                    
                } catch {
                    completion(Result.failure(.decodingError(error as? DecodingError)))
                }
            }
        }.resume()
    }
    
    func createURL(for searchTerm: String?, type: LaunchType, page: Int?, limit: Int?) -> URL? {
        var baseURL = "https://lldev.thespacedevs.com/2.2.0/launch/"
        
        switch type {
        case .all:
            break
        case .previous:
            baseURL.append("previous")
        case .upcoming:
            baseURL.append("upcoming")

        }
        
        var queryItems = [URLQueryItem]()
        
        if let searchTerm = searchTerm {
                queryItems.append(URLQueryItem(name: "search", value: searchTerm))
        }
        
        if let page = page, let limit = limit {
            let offset = page * limit
            queryItems.append(URLQueryItem(name: "mode", value: "detailed"))
            queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
            queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
        }
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = queryItems
        print(components?.url as Any)
        return components?.url
    }
}
