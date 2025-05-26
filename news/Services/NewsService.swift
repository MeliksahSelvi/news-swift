//
//  NewsService.swift
//  news
//
//  Created by Melik on 22.05.2025.
//

import Foundation

protocol NewsServiceProtocol {
    func fetchTopNews(
        country: String,
        page: Int,
        pageSize: Int,
        completion: @escaping (Result<NewsModel,NetworkError>) -> Void
    )
    
    func searchNews(
        text: String,
        page: Int,
        pageSize: Int,
        completion: @escaping (Result<NewsModel,NetworkError>) -> Void
    )
}

final class NewsService : NewsServiceProtocol{

    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchTopNews(country: String, page: Int, pageSize: Int, completion: @escaping (Result<NewsModel, NetworkError>) -> Void) {
        var urlComponents = URLComponents(string: NetworkConstants.baseURL + "top-headlines")
        urlComponents?.queryItems = [
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "pageSize", value: String(pageSize)),
            URLQueryItem(name: "apiKey", value: NetworkConstants.apiKey)
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidRequest))
            return
        }
        
        networkManager.request(url : url, method: .GET, completion: completion)
        
    }
    
    func searchNews(text: String, page: Int, pageSize: Int, completion: @escaping (Result<NewsModel, NetworkError>) -> Void) {
        var urlComponents = URLComponents(string: NetworkConstants.baseURL + "top-headlines")
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "pageSize", value: String(pageSize)),
            URLQueryItem(name: "apiKey", value: NetworkConstants.apiKey)
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidRequest))
            return
        }
        
        networkManager.request(url: url, method: .GET, completion: completion)
    }
}
