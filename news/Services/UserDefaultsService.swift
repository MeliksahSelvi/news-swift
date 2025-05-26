//
//  UserDefaultsService.swift
//  news
//
//  Created by Melik on 19.05.2025.
//

import Foundation
import UIKit
protocol UserDefaultsServiceProtocol {
    func getUsername() -> String?
    func saveUsername(_ username: String)
    func removeUsername()
    func getTheme() -> Int
    func saveTheme(_ theme: Int)
    func removeTheme()
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    func getUsername() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.USERNAME)
    }
    
    func saveUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: UserDefaultKeys.USERNAME)
    }
    
    func removeUsername() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.USERNAME)
    }
    
    func getTheme() -> Int {
        return UserDefaults.standard.integer(forKey: UserDefaultKeys.THEME)
    }
    
    func saveTheme(_ theme: Int) {
        UserDefaults.standard.set(theme, forKey: UserDefaultKeys.THEME)
    }
    
    func removeTheme() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.THEME)
    }
}
