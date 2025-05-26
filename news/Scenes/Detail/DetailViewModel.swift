//
//  DetailViewModel.swift
//  news
//
//  Created by Melik on 22.05.2025.
//

protocol DetailViewModelProtocol : AnyObject {
    func assignDelegate(delegate: DetailViewControllerProtocol )
    func getArticle() -> Article
}

final class DetailViewModel : DetailViewModelProtocol {
    
    private weak var delegate : DetailViewControllerProtocol?

    private let article : Article
    
    init(article: Article) {
        self.article = article
    }
    
    func assignDelegate(delegate: DetailViewControllerProtocol ) {
        self.delegate = delegate
    }
    
    func getArticle() -> Article {
        return self.article
    }
}

final class PreviewDetailViewModel : DetailViewModelProtocol {
    func assignDelegate(delegate: DetailViewControllerProtocol ){}
    func getArticle() -> Article {Article(title: "Title afgesgfwafwafwafwafwafwafaw", description: "awfawfwafwafwafwa", author: "Ertem Şener", url: nil, urlToImage: nil, publishedAt: nil, content: nil)
    }
}
