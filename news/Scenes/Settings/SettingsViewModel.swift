//
//  SettingsViewModel.swift
//  news
//
//  Created by Melik on 19.05.2025.
//

import Foundation
import UserNotifications

protocol SettingsViewModelProtocol : AnyObject {
    
    func assignDelegate(delegate: SettingsViewControllerProtocol )
    func getSelectedSegmentControlIndex() -> Int
    func getSections() -> [SettingsSection]
    func updateNotificationSwitch(_ completion: @escaping (_ isAuthorized : Bool) -> Void)
    func requestNotificationPermission( cancellationCompletion: @escaping (Bool) -> Void)
    func updateThemeMode(_ mode: Int)
}

final class SettingsViewModel : SettingsViewModelProtocol {
    
    private weak var delegate : SettingsViewControllerProtocol?
    
    private let userDefaultService : UserDefaultsServiceProtocol
    
    private var sections : [SettingsSection] = SettingsSection.sections

    init(userDefaultService: UserDefaultsServiceProtocol) {
        self.userDefaultService = userDefaultService
    }
    
    func assignDelegate(delegate: SettingsViewControllerProtocol) {
        self.delegate = delegate
    }
    
    func getSelectedSegmentControlIndex() -> Int {
        return userDefaultService.getTheme()
    }
    
    func getSections() -> [SettingsSection] {
        return self.sections
    }
    
    func requestNotificationPermission(cancellationCompletion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("İzin hatası: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                if granted {
                    print("İzin verildi")
                } else {
                    print("İzin reddedildi")
                    cancellationCompletion(false)
                }
            }
        }
    }
    
    func updateNotificationSwitch(_ completion: @escaping (_ isAuthorized: Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    func updateThemeMode(_ mode: Int){
        userDefaultService.saveTheme(mode)
        self.delegate?.didUpdateTheme(mode: mode)
    }
}

final class PreviewSettingsViewModel : SettingsViewModelProtocol {
    
    func assignDelegate(delegate: SettingsViewControllerProtocol ){}
    func getSelectedSegmentControlIndex() -> Int {return 0}
    func getSections() -> [SettingsSection] {[]}
    func updateNotificationSwitch(_ completion: @escaping (_ isAuthorized: Bool) -> Void) {
        completion(false)
    }
    func requestNotificationPermission(cancellationCompletion: @escaping (Bool) -> Void) {
        cancellationCompletion(false)
    }
    func updateThemeMode(_ mode: Int) {}
}
