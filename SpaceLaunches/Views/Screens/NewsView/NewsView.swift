//
//  NewsView.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 30/11/2023.
//

import SwiftUI

struct NewsView: View {
    
    @StateObject var viewModel = NewsViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                List {
                    ForEach(viewModel.news) { article in
                        Text(article.title)
                    }
                    
                    switch viewModel.state {
                    case .good:
                        Color.clear
                            .onAppear {
                                viewModel.loadMore()
                            }
                    case .isLoading:
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(maxWidth: .infinity)
                            .id(UUID())
                    case .loadedAll:
                        EmptyView()
                    case .error:
                        ErrorPlaceholderView()
                            .frame(height: geo.size.height / 1.1)
                            .frame(maxWidth: .infinity)
                            .listRowSeparator(.hidden)
                    case .isEmpty:
                        VStack(alignment: .center) {
                            LaunchLoadingView()
                                .frame(height: geo.size.height / 1.1)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    viewModel.loadMore()
                }
            }
        }
        .searchable(text: $viewModel.searchTerm)

    }
}

#Preview {
    NewsView()
}
