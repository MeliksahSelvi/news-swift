//
//  DetailViewController.swift
//  news
//
//  Created by Melik on 22.05.2025.
//

import UIKit

protocol DetailViewControllerProtocol: AnyObject {
    
}

class DetailViewController: UIViewController {
    
    private var viewModel: DetailViewModelProtocol
    
    private let scrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemGray6
        return scrollView
    }()
    
    private lazy var mainTitle: UILabel = {
        let mainTitle = UILabel()
        mainTitle.text = self.viewModel.getArticle().title
        mainTitle.numberOfLines = 2
        mainTitle.textAlignment = .left
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        mainTitle.font = .preferredFont(forTextStyle: .largeTitle).withTraits(traits: .traitBold)
        return mainTitle
    }()
    
    private lazy var imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.kf.setImage(with: URL(string: self.viewModel.getArticle().urlToImage ?? ""), placeholder: UIImage(systemName: "photo.artframe"))
        return imageView
    }()
    
    private lazy var paragraphText: UILabel = {
        let paragraphText = UILabel()
        paragraphText.text = self.viewModel.getArticle().description
        paragraphText.textAlignment = .left
        paragraphText.numberOfLines = 0
        paragraphText.translatesAutoresizingMaskIntoConstraints = false
        paragraphText.font = .preferredFont(forTextStyle: .body)
        return paragraphText
    }()
    
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildViews()
    }
}

extension DetailViewController: DetailViewControllerProtocol {
    
    func buildViews(){
        view.backgroundColor = .systemGray6
        let icon = UIImage(systemName: "square.and.arrow.up")
        let rightButton = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(didTapRightButton))
        navigationItem.rightBarButtonItem = rightButton
        
        addViews()
        buildConstraints()
    }
    
    func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainTitle)
        scrollView.addSubview(imageView)
        scrollView.addSubview(paragraphText)
    }

    func buildConstraints() {
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
    
        //constraints.append(mainTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16))
        
        constraints.append(imageView.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 24))
        constraints.append(imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12))
        constraints.append(imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -12))
        constraints.append(imageView.heightAnchor.constraint(equalToConstant: 250))
        constraints.append(imageView.widthAnchor.constraint(equalTo:scrollView.widthAnchor))
        
        constraints.append(paragraphText.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20))
        constraints.append(paragraphText.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16))
        constraints.append(paragraphText.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16))
        
        NSLayoutConstraint.activate(constraints)
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

@objc private extension DetailViewController {
    func didTapRightButton(button: UIButton) {
        print("Sağ üst ikon tıklandı!")
        let shareSheetVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
        let shareAction = UIAlertAction(title: "News.shareLinkTitle".localized, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presentShareSheet(button: button,article: self.viewModel.getArticle())
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
    
    
}


#Preview {
    let viewModel : DetailViewModelProtocol = PreviewDetailViewModel()
    DetailViewController(viewModel: viewModel)
}
