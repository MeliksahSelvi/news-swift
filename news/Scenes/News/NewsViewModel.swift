//
//  NewsViewModel.swift
//  news
//
//  Created by Melik on 19.05.2025.
//

import Foundation

protocol NewsViewModelProtocol : AnyObject {
    
    func assignDelegate(delegate: NewsViewControllerProtocol )
    func searchNewsByText(_ text: String)
    func getNews() -> [Article]
    func fetchTopNews()
    func loadMore()
}

final class NewsViewModel : NewsViewModelProtocol {
    
    private weak var delegate : NewsViewControllerProtocol?

    private let userDefaultsService: UserDefaultsServiceProtocol
    private let newsService: NewsServiceProtocol
    
    private var mode : ControllerMode = .top
    private var page : Int = 1
    private let pageSize : Int = 20
    private var isLoading : Bool = false
    
    private let debounceInterval : TimeInterval = 1
    private var debounceWorkItem: DispatchWorkItem?
    
    private var articles: [Article] = []
    
    deinit{
        debounceWorkItem?.cancel()
    }
    
    init(userDefaultsService: UserDefaultsServiceProtocol, newsService: NewsServiceProtocol) {
        self.userDefaultsService = userDefaultsService
        self.newsService = newsService
    }

    func assignDelegate(delegate: NewsViewControllerProtocol ) {
        self.delegate = delegate
    }
    
    func getNews() -> [Article] {
        return articles
    }
    
    func searchNewsByText(_ text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        debounceWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.mode = trimmedText.isEmpty ? .top : .search(trimmedText)
            self.fetch(reset: true)
        }
        
        debounceWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: workItem)
    }
    
    func fetchTopNews() {
        fetch(reset: true)
    }
    
    func fetch(reset : Bool) {
        
        guard isLoading == false else { return }
        isLoading = true
        
        if reset {
            page = 1
        }
        let completion: (Result<NewsModel,NetworkError>) -> Void = { [weak self] result in
                guard let self = self else { return }
            
            isLoading = false
            switch result {
            case .success(let result):
                if reset {
                    self.articles = result.articles
                }else{
                    self.articles += result.articles
                }
                
                self.delegate?.updateData()
            case .failure(let error):
                print("Failed to fetch news: \(error)")
            }
        }
        
        switch mode {
        case .top:
            newsService.fetchTopNews(country: "us", page: page, pageSize: pageSize,completion: completion)
        case .search(let text):
            newsService.searchNews(text: text, page: page, pageSize: pageSize, completion: completion)
        }
    }
    
    func loadMore() {
        page += 1
        fetch(reset: false)
    }
}

final class PreviewNewsViewModel : NewsViewModelProtocol {
    
    func assignDelegate(delegate: NewsViewControllerProtocol ){}
    func searchNewsByText(_ text: String) {}
    func getNews() -> [Article] { [] }
    func fetchTopNews() {}
    func loadMore() {}
}
