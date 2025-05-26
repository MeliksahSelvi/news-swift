//
//  NewsViewController.swift
//  news
//
//  Created by Melik on 19.05.2025.
//

import UIKit

protocol NewsViewControllerProtocol : AnyObject{
    func updateData()
}

class NewsViewController: UIViewController, NewsViewControllerProtocol {

    private let viewModel: NewsViewModelProtocol

    private let onNavigateDetailView: ((Article) -> Void)
    
    private lazy var newsCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray6
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: "NewsCell")
        return collectionView
    }()
    
    private lazy var searchController : UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "News.placeHolder".localized
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    init(viewModel: NewsViewModelProtocol, onNavigateDetailView: @escaping ((Article) -> Void)) {
        self.viewModel = viewModel
        self.onNavigateDetailView = onNavigateDetailView
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        self.viewModel.fetchTopNews()
    }
    
    func updateData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.newsCollectionView.reloadData()
        }
    }
}

extension NewsViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.viewModel.searchNewsByText("")
        }else if searchText.count >= 3 {
            self.viewModel.searchNewsByText(searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchNewsByText("")
    }
}

extension NewsViewController : NewsCellDelegate{

    func didClickedEllipsis(article: Article,button: UIButton) {
        let shareSheetVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
        let shareAction = UIAlertAction(title: "News.shareLinkTitle".localized, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presentShareSheet(button: button,article: article)
        }
        
        let cancelAction = UIAlertAction(title: "News.cancelSharing".localized, style: .cancel)
                
        shareSheetVC.addAction(shareAction)
        shareSheetVC.addAction(cancelAction)
                
        // iPad uyumluluğu için popover ayarı
        if let popover = shareSheetVC.popoverPresentationController {
            popover.sourceView = button
            popover.sourceRect = button.bounds
        }
                
        present(shareSheetVC, animated: true)
    }
    
    func presentShareSheet(button: UIButton, article : Article) {
        let newsLink: URL? = URL(string: article.url ?? "https://www.google.com")
        let items: [Any] = [newsLink]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            
        // iPad uyumluluğu
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = button
            popover.sourceRect = button.bounds
        }
        present(activityVC, animated: true)
    }
}

extension NewsViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.configure(article: viewModel.getNews()[indexPath.row],delegate: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNews().count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArticle = viewModel.getNews()[indexPath.row]
        self.onNavigateDetailView(selectedArticle)
        
        newsCollectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getNews().count - 1 {
            viewModel.loadMore()
        }
    }
}

private extension NewsViewController {
    
    func buildViews(){
        view.backgroundColor = .systemGray6
        self.navigationItem.backButtonTitle = "News.backButtonTitle".localized
        self.navigationItem.searchController = searchController
        addViews()
        buildConstraints()
    }
    
    func addViews(){
        view.addSubview(newsCollectionView)
    }
    
    func buildConstraints() {
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(newsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16))
        constraints.append(newsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16))
        constraints.append(newsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30))
        constraints.append(newsCollectionView.topAnchor.constraint(equalTo: view.topAnchor,constant: 100))
    
        NSLayoutConstraint.activate(constraints)
    }
}


 #Preview {
     let viewModel : NewsViewModelProtocol = PreviewNewsViewModel()
     NewsViewController(viewModel: viewModel,onNavigateDetailView: {task in})
 }
