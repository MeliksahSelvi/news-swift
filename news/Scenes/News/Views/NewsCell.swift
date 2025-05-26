//
//  NewsCell.swift
//  news
//
//  Created by Melik on 20.05.2025.
//

import UIKit
import Kingfisher

protocol NewsCellDelegate: AnyObject {
    func didClickedEllipsis(article: Article,button: UIButton)
}

class NewsCell : UICollectionViewCell {
    
    private weak var delegate: NewsCellDelegate?

    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.image = UIImage(systemName: "photo.artframe")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let captionLabel: UILabel = {
        let captionLabel: UILabel = UILabel()
        captionLabel.numberOfLines = 2
        captionLabel.font = .preferredFont(forTextStyle: .callout).withTraits(traits: .traitBold)
        captionLabel.textColor = .label
        captionLabel.textAlignment = .left
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        return captionLabel
    }()
    
    private let authorLabel: UILabel = {
        let authorLabel: UILabel = UILabel()
        authorLabel.numberOfLines = 1
        authorLabel.font = .preferredFont(forTextStyle: .caption1)
        authorLabel.textColor = .systemGray
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        return authorLabel
    }()
    
    private let categoryLabel: UILabel = {
        let categoryLabel: UILabel = UILabel()
        categoryLabel.numberOfLines = 1
        categoryLabel.font = .preferredFont(forTextStyle: .caption1)
        categoryLabel.textColor = .systemBlue
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        return categoryLabel
    }()
    
    private let circleImageView : UIImageView = {
        let circleImageView: UIImageView = UIImageView(image: UIImage(systemName: "circle.fill"))
        circleImageView.contentMode = .scaleAspectFill
        circleImageView.translatesAutoresizingMaskIntoConstraints = false
        circleImageView.tintColor = .systemGray
        return circleImageView
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel: UILabel = UILabel()
        dateLabel.numberOfLines = 1
        dateLabel.font = .preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .systemGray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    private lazy var ellipsisButton: UIButton = {
        let ellipsisButton: UIButton = UIButton(type: .custom)
        ellipsisButton.tintColor = .label
        ellipsisButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        ellipsisButton.translatesAutoresizingMaskIntoConstraints = false
        ellipsisButton.addTarget(self, action: #selector(ellipsisTapped), for: .touchUpInside)
        return ellipsisButton
    }()
    
    private let divider = {
        let divider: UIView = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .systemGray4
        return divider
    }()
    
    private var article: Article?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func configure(article: Article,delegate : NewsCellDelegate) {
        self.delegate = delegate
        self.article = article
        captionLabel.text = article.title
        authorLabel.text = article.author
        dateLabel.text = self.timeAgoString(from: article.publishedAt)
        imageView.kf.setImage(with: URL(string: article.urlToImage ?? ""))
        categoryLabel.text = "Economy"
    }
    
    func timeAgoString(from dateAsStr: String?) -> String {
        if let dateAsStr = dateAsStr {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = formatter.date(from: dateAsStr) as Date? {
                let now = Date()
                let secondsAgo = Int(now.timeIntervalSince(date))

                if secondsAgo < 60 {
                    let secondTimePostFix = "News.secondTimePostFix".localized
                    return "\(secondsAgo)\(secondTimePostFix)"
                } else if secondsAgo < 3600 {
                    let minuteTimePostFix = "News.minuteTimePostFix".localized
                    return "\(secondsAgo / 60)\(minuteTimePostFix)"
                } else if secondsAgo < 86400 {
                    let hourTimePostFix = "News.hourTimePostFix".localized
                    return "\(secondsAgo / 3600)\(hourTimePostFix)"
                } else {
                    let dayTimePostFix = "News.dayTimePostFix".localized
                    return "\(secondsAgo / 86400)\(dayTimePostFix)"
                }
            }
        }
        
        return Date().description
    }
}

private extension NewsCell {
    
    func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(captionLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(circleImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(ellipsisButton)
        contentView.addSubview(divider)
        
        buildConstraints()
    }
    
    

    func buildConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2))
        constraints.append(imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12))
        constraints.append(imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24))
        constraints.append(imageView.heightAnchor.constraint(equalToConstant: 120))
        constraints.append(imageView.widthAnchor.constraint(equalToConstant: 120))
        
        constraints.append(captionLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor))
        constraints.append(captionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12))
        constraints.append(captionLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor))
        
        constraints.append(authorLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 12))
        constraints.append(authorLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12))
        constraints.append(authorLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor))
        
        constraints.append(dateLabel.leadingAnchor.constraint(equalTo: circleImageView.trailingAnchor ,constant: 12))
        constraints.append(dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24))
        
        constraints.append(categoryLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12))
        constraints.append(categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24))
        
        constraints.append(circleImageView.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 12))
        constraints.append(circleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24))
        constraints.append(ellipsisButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor))
        constraints.append(ellipsisButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor))
        constraints.append(ellipsisButton.widthAnchor.constraint(equalToConstant: 24))
        
        constraints.append(circleImageView.heightAnchor.constraint(equalToConstant: 8))
        constraints.append(circleImageView.widthAnchor.constraint(equalToConstant: 8))
        
        constraints.append(divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4))
        constraints.append(divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4))
        constraints.append(divider.heightAnchor.constraint(equalToConstant: 0.5))
        constraints.append(divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
}

@objc private extension NewsCell {
 
    func ellipsisTapped() {
        self.delegate?.didClickedEllipsis(article: self.article!,button: self.ellipsisButton)
    }
}
