//
//  AppCoordinator.swift
//  news
//
//  Created by Melik on 27.05.2025.
//

import UIKit
import Kingfisher

final class AppCoordinator {
    private let window: UIWindow
    private let navigator: AppNavigator
    
    init(window: UIWindow) {
        self.window = window
        self.navigator = AppNavigator(window: window)
    }
    
    func start() {
        let userDefaultsService = UserDefaultsService()
        let newsService = NewsService(networkManager: NetworkManager())
        
        KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
        KingfisherManager.shared.cache.memoryStorage.config.expiration = .seconds(300)
        
        applySavedTheme(userDefaultsService)
        
        navigator.start(userDefaultsService: userDefaultsService, newsService: newsService)
    }
    
    private func applySavedTheme(_ userDefaultService: UserDefaultsServiceProtocol) {
        let themeMode = userDefaultService.getTheme()
        print("themeMode: \(themeMode)")
        switch themeMode {
        case 0:
            window.overrideUserInterfaceStyle = .unspecified
        case 1:
            window.overrideUserInterfaceStyle = .light
        case 2:
            window.overrideUserInterfaceStyle = .dark
        default:
            window.overrideUserInterfaceStyle = .unspecified
        }
    }
}
