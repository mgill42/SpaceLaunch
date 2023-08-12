//
//  ContentView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 10/08/2023.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    
    @State private var events: Events?
    @State private var launches: Launches?

    var body: some View {
        VStack {
            List(launches?.results ?? []) { launch in
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(launch.name)
                            .bold()
                            .font(.subheadline)
                        Text(launch.launchServiceProvider.name)
                        VStack(alignment: .leading, spacing: 5) {
                            Label(convertDateToString(launch.windowStart), systemImage: "calendar")
                            Label(launch.pad.location.countryCode, systemImage: "location")


                        }
                        .font(.caption)
                        .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    KFImage(URL(string: launch.agencyMain?.logoUrl ?? ""))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
            }
        }

        .task {
            do {
                launches = try await getLaunches()
                
                for i in 0..<launches!.results.count {
                    launches?.results[i].agencyMain = try await getAgency(endpoint: launches?.results[i].launchServiceProvider.url ?? "")
                    
                }
            } catch SLError.invalidURL {
                print("Invalid URL")
            } catch SLError.invalidResponse {
                print("Invalid Response")
            } catch SLError.invalidData {
                print("Invalid Data")
            } catch {
                print("Unexpected Error")
            }
            
            
        }
    }
    
    func convertDateToString( _ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ssZ"
        guard let date = inputFormatter.date(from: dateString) else { return "Error" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM d yyyy"
        
        return outputFormatter.string(from: date)
    }
    
    
    func getAgency(endpoint: String) async throws -> Agency {
        guard let url = URL(string: endpoint) else {
            throw SLError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SLError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Agency.self, from: data)
        } catch {
            throw SLError.invalidData
        }
    }
    
    func getLaunches() async throws -> Launches {
        let endpoint = "https://lldev.thespacedevs.com/2.2.0/launch/upcoming"
        
        guard let url = URL(string: endpoint) else {
            throw SLError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SLError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Launches.self, from: data)
        } catch {
            throw SLError.invalidData
        }
    }
    
    func getEvents() async throws -> Events {
        let endpoint = "https://lldev.thespacedevs.com/2.2.0/event/upcoming/?ordering=date&limit=20"
        
        guard let url = URL(string: endpoint) else {
            throw SLError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SLError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Events.self, from: data)
        } catch {
            throw SLError.invalidData
        }
    }
    
    enum SLError: Error {
        case invalidURL
        case invalidResponse
        case invalidData

    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
