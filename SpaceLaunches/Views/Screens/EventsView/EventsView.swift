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
        NavigationView {
            List {
                ForEach(events) { event in
                    if let newsURL = URL(string: event.newsUrl ?? "") {
                        Link(destination: newsURL, label: {
                            EventCell(event: event)
                        })
                    } else if let videoURL = URL(string: event.videoUrl ?? "") {
                        Link(destination: videoURL, label: {
                            EventCell(event: event)
                        })
                    } else {
                        EventCell(event: event)
                    }
                }
                
                
                
                switch state {
                case .good:
                    Color.clear
                        .onAppear {
                            state = .isLoading
                            service.fetchEvents { result in
                                switch result {
                                case .success(let results):
                                    for event in results.results {
                                        events.append(event)
                                    }
                                    state = .loadedAll
                                case .failure(let error):
                                    state = .error("Could not load: \(error)")
                                }
                            }
                        }
                case .isLoading:
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity)
                        .id(UUID())
                case .loadedAll:
                    Color.gray
                    
                case .error(let message):
                    Text(message)
                        .foregroundColor(.pink)
                }
            }
            .navigationTitle("Events")
            .listStyle(.plain)
        }
    }
}

#Preview {
    EventsView()
}


