//
//  OnboardingViewController.swift
//  news
//
//  Created by Melik on 19.05.2025.
//

import UIKit

protocol OnboardingViewControllerProtocol : AnyObject{
    
    func updateStartButtonValidity(isEnabled: Bool)
    func navigateToNews()
}

class OnboardingViewController: UIViewController, OnboardingViewControllerProtocol {
    
    private let viewModel: OnboardingViewModelProtocol
    private let onNavigateNews: (() -> Void)
    
    private let scrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "alarm")
        imageView.tintColor = .systemOrange
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Onboarding.mainTitle".localized
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Onboarding.placeHolder".localized
        textField.textColor = .label
        textField.font = .preferredFont(forTextStyle: .extraLargeTitle)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var startButton: UIButton = {
        let startButton = UIButton(type: .custom)
        startButton.backgroundColor = .systemOrange
        startButton.setTitle("Onboarding.buttonText".localized, for: .normal)
        startButton.setTitleColor(.white, for: .normal) //TODO: change white
        startButton.layer.cornerRadius = 16
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        startButton.titleLabel?.textAlignment = .center
        startButton.contentHorizontalAlignment = .center
        startButton.contentVerticalAlignment = .center
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        startButton.isEnabled = false
        startButton.alpha = 0.5
        return startButton
    }()
    
    init(viewModel: OnboardingViewModelProtocol,onNavigateNews: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onNavigateNews = onNavigateNews
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
     
    func updateStartButtonValidity(isEnabled: Bool) {
        self.startButton.isEnabled = isEnabled
        self.startButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    func navigateToNews() {
        onNavigateNews()
    }
}

extension OnboardingViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        handleLogin()
        return true
    }
}

private extension OnboardingViewController {
    
    func buildViews(){
        view.backgroundColor = .systemBackground
        addViews()
        buildConstraints()
    }
    
    func addViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(textField)
        scrollView.addSubview(startButton)
    }
    
    func buildConstraints() {
        
        var constraints: [NSLayoutConstraint] = []

        constraints.append(scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 12))
        constraints.append(scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12))
        constraints.append(scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32))
        constraints.append(imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor))
        constraints.append(imageView.widthAnchor.constraint(equalToConstant: 100))
        constraints.append(imageView.heightAnchor.constraint(equalToConstant: 100))
        constraints.append(titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor))
        constraints.append(titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30))
        constraints.append(textField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor))
        constraints.append(textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60))
        constraints.append(startButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30))
        constraints.append(startButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1))
        constraints.append(startButton.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.1))
        NSLayoutConstraint.activate(constraints)
    }
}

@objc private extension OnboardingViewController {
    
    func handleLogin() {
        viewModel.saveUsername()
    }
    
    
    func textFieldDidChange(_ textField: UITextField) {
        viewModel.updateUsername(textField.text ?? "")
    }
}

 #Preview {
     let viewModel : OnboardingViewModelProtocol = PreviewOnboardingViewModel()
     OnboardingViewController(viewModel: viewModel, onNavigateNews: {})
 }
