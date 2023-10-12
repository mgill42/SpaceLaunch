//
//  EventsView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 10/10/2023.
//

import SwiftUI
import Kingfisher

struct EventsView: View {
    
    let service = APIService()
    @State var events: [Event] = []
    @State var state: FetchState = .good



    var body: some View {
        List {
            ForEach(events) { event in
                EventCell(event: event)
            }
        }
        .navigationTitle("Events")
        .listStyle(.plain)
        .task {
            service.fetchEvents { result in
                switch result {
                case .success(let results):
                    for event in results.results {
                        events.append(event)
                    }
                case .failure(let error):
                    state = .error("Could not load: \(error)")
                }
            }
        }
    }
}

#Preview {
    EventsView()
}


