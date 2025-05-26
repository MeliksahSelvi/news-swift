//
//  AppNavigator.swift
//  news
//
//  Created by Melik on 19.05.2025.
//

import UIKit

final class AppNavigator {
    
    private let window: UIWindow
    private var navigationController: UINavigationController?

    init(window: UIWindow) {
        self.window = window
    }
    
    func start(userDefaultsService: UserDefaultsServiceProtocol,newsService: NewsServiceProtocol) {
        let splashViewModel = SplashViewModel(userDefaultsService: userDefaultsService)
        let splashViewController = SplashViewController(
            viewModel: splashViewModel,
            onNavigateOnboarding: { [weak self] in
                self?.navigateOnboarding(userDefaultsService: userDefaultsService, newsService: newsService)
            },
            onNavigateNews: { [weak self] in
                self?.navigateNews(userDefaultsService: userDefaultsService, newsService: newsService)
            }
        )
        splashViewModel.assignDelegate(delegate: splashViewController)
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }
    
    private func navigateOnboarding(userDefaultsService: UserDefaultsServiceProtocol, newsService: NewsServiceProtocol ) {
        let onboardingViewModel = OnboardingViewModel(userDefaultsService: userDefaultsService)
        let onboardingViewController = OnboardingViewController(
            viewModel: onboardingViewModel,
            onNavigateNews: { [weak self] in
                self?.navigateNews(userDefaultsService: userDefaultsService, newsService: newsService)
            }
        )
        onboardingViewModel.assignDelegate(delegate: onboardingViewController)
        window.rootViewController = onboardingViewController
        window.makeKeyAndVisible()
    }

    private func navigateNews(userDefaultsService: UserDefaultsServiceProtocol,newsService: NewsServiceProtocol) {
        let newsViewModel : NewsViewModelProtocol = NewsViewModel(userDefaultsService: userDefaultsService,newsService: newsService)
        let newsViewController = NewsViewController(
            viewModel: newsViewModel,
            onNavigateDetailView: { [weak self] article in
                self?.navigateDetailView(article: article)
            }
        )
        newsViewModel.assignDelegate(delegate: newsViewController)
        newsViewController.navigationItem.largeTitleDisplayMode = .always
        newsViewController.title = "News.tabBarTitle".localized
        
        let newsVC = UINavigationController(rootViewController: newsViewController)
        newsVC.tabBarItem = UITabBarItem(title : "News.tabBarTitle".localized, image: UIImage(systemName: "newspaper"), tag: 0)
        newsVC.navigationBar.prefersLargeTitles = true
        
        let settingsViewModel: SettingsViewModelProtocol = SettingsViewModel(userDefaultService: userDefaultsService)
        let settingsViewController = SettingsViewController(viewModel : settingsViewModel)
        settingsViewController.title = "Settings.tabBarTitle".localized
        settingsViewController.navigationItem.largeTitleDisplayMode = .always
        settingsViewModel.assignDelegate(delegate: settingsViewController)
        
        let settingsVC = UINavigationController(rootViewController: settingsViewController)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings.tabBarTitle".localized, image: UIImage(systemName: "gear"), tag: 1)
        settingsVC.navigationBar.prefersLargeTitles = true
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [newsVC, settingsVC]
        tabBarController.selectedIndex = 0
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.navigationController = newsVC
    }
    
    private func navigateDetailView(article : Article) {
        let viewModel : DetailViewModelProtocol = DetailViewModel(article: article)
        let detailViewController = DetailViewController(viewModel: viewModel)
        viewModel.assignDelegate(delegate: detailViewController)
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
}
