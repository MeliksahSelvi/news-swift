//
//  NewsModel.swift
//  news
//
//  Created by Melik on 24.05.2025.
//

struct NewsModel: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String?
    let description: String?
    let author: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
