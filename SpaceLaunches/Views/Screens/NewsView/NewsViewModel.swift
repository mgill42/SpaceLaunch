//
//  NewsViewModel.swift
//  SpaceLaunches
//
//  Created by Mahaveer Gill on 30/11/2023.
//

import Foundation
import Combine

@MainActor final class NewsViewModel: ObservableObject {
    
    @Published var news: [Article] = []
    @Published var searchTerm: String = ""
    @Published var state: FetchState = .good
    
    let service = APIService()
    var subscriptions = Set<AnyCancellable>()

    let limit: Int = 20
    var page: Int = 0

    init() {
        $searchTerm
            .removeDuplicates()
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] term in
                self?.clear()
                self?.fetchNews(for: term)
        }.store(in: &subscriptions)
    }
    
    func clear() {
        state = .good
        page = 0
        news = []
    }
    
    func loadMore() {
        fetchNews(for: searchTerm)
    }
    
    func fetchNews(for searchTerm: String?) {
      
        guard state == .good || state == .error else {
            return
        }
        
        state = news.isEmpty ? .isEmpty : .isLoading
        
        service.fetchNews(searchTerm: searchTerm, page: page, limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    for article in results.results {
                        self?.news.append(article)
                    }
                    self?.page += 1
                    self?.state = (results.results.count == self?.limit) ? .good : .loadedAll
                case .failure(_):
                    self?.state = .error
                    
                }
            }
        }
    }
}
