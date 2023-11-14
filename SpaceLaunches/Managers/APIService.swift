//
//  APIService.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 20/09/2023.
//

import Foundation

class APIService {
    
    func fetchHighlightLaunch(completion: @escaping(Result<Launch, APIError>) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let url = createLaunchURL(for: nil, type: .upcoming, page: 0, limit: 5)
        fetch(type: Launches.self, url: url) { result in
            switch result {
            case .success(let success):
                let highLightedLaunch = success.results.first(where: {
                    
                    if let date = dateFormatter.date(from: $0.net) {
                        return date > Date()
                    } else {
                        return true
                    }
                    
                })
                if let highLightedLaunch = highLightedLaunch {
                    completion(Result.success(highLightedLaunch))
                }

            case .failure(_):
                completion(Result.failure(APIError.unknown))
            }
        }
    }


    func getDataFromUrl(url: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
    
    func fetchLaunches(searchTerm: String?, page: Int, limit: Int, type: LaunchType, completion: @escaping(Result<Launches,APIError>) -> Void) {
        let url = createLaunchURL(for: searchTerm, type: type, page: page, limit: limit)
        fetch(type: Launches.self, url: url,completion: completion)
    }
    
    func fetchEvents(completion: @escaping(Result<Events, APIError>) -> Void) {
        let url = URL(string: "https://lldev.thespacedevs.com/2.2.0/event/upcoming/?ordering=+date")
        fetch(type: Events.self, url: url, completion: completion)
    }
    
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
    

    
    func createLaunchURL(for searchTerm: String?, type: LaunchType, page: Int?, limit: Int?) -> URL? {
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
        return components?.url
    }
}
