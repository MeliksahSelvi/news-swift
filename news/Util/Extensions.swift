//
//  Extensions.swift
//  news
//
//  Created by Melik on 19.05.2025.
//

import UIKit

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0) // 0 = mevcut boyut kullanılır
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
