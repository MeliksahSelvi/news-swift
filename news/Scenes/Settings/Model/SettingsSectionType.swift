//
//  SettingsSectionType.swift
//  news
//
//  Created by Melik on 19.05.2025.
//

enum SettingsSectionType {
    case theme
    case notification
    case rateApp
    case privacyPolicy
    case termOfUse
}

struct SettingsItem {
    let title: String
    let iconName: String
    let type : SettingsSectionType
}

struct SettingsSection {
    let title: String
    let items: [SettingsItem]
    
    static let sections: [SettingsSection] = [
        SettingsSection(title: "Settings.appTheme".localized, items: [
            SettingsItem(title: "Settings.appTheme".localized, iconName: "circle.righthalf.filled", type: .theme)
        ]),
        SettingsSection(title: "Settings.notification".localized, items: [
            SettingsItem(title: "Settings.notification".localized,iconName: "bell.fill", type: .notification)
        ]),
        SettingsSection(title: "Settings.rateUs".localized, items: [
            SettingsItem(title: "Settings.rateUs".localized, iconName: "star.fill", type: .rateApp)
        ]),
        SettingsSection(title: "Settings.privacyPolicy".localized, items: [
            SettingsItem(title: "Settings.privacyPolicy".localized, iconName: "text.document.fill", type: .privacyPolicy),
            SettingsItem(title: "Settings.termOfUse".localized, iconName: "checkmark.shield.fill", type: .termOfUse)
        ])
    ]
}
