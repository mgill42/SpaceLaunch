//
//  EventsView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 10/10/2023.
//

import SwiftUI
import Kingfisher

struct EventsView: View {

    @StateObject var viewModel = EventsViewModel()

    var body: some View {
        GeometryReader { geo in
            
            NavigationView {
                List {
                    ForEach(viewModel.events) { event in
                        Group {
                            if let newsURL = URL(string: event.newsUrl ?? "") {
                                Link(destination: newsURL, label: {
                                    EventCell(event: event)
                                })
                                .listRowSeparator(.hidden)
                            } else if let videoURL = URL(string: event.videoUrl ?? "") {
                                Link(destination: videoURL, label: {
                                    EventCell(event: event)
                                })
                                .listRowSeparator(.hidden)
                            } else {
                                EventCell(event: event)
                                    .listRowSeparator(.hidden)
                            }
                        }
                        .padding(.vertical, 20)
                    }
                    switch viewModel.state {
                    case .good:
                        Color.clear
                            .onAppear {
                                viewModel.fetchEvents()
                            }
                    case .isLoading:
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(maxWidth: .infinity)
                            .id(UUID())
                    case .loadedAll:
                        EmptyView()
                    case .error(let message):
                        ErrorPlaceholderView()
                            .frame(height: geo.size.height / 1.3)
                            .frame(maxWidth: .infinity)
                            .listRowSeparator(.hidden)
                    case .isEmpty:
                        EventsLoadingView()
                            .frame(height: geo.size.height / 1.3)
                            .listRowSeparator(.hidden)
                    }
                    
                }
                .navigationTitle("Upcoming Events")
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    EventsView()
}


