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
                    Text(message)
                        .foregroundColor(.pink)
                case .isEmpty:
                    EventsLoadingView()
                        .listRowSeparator(.hidden)
                        .padding(.top, 150)
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


