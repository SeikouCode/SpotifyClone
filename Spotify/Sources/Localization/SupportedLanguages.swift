//
//  SupportedLanguages.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
//

import Foundation

enum SupportedLanguages: String {
    case ru
    case en
    
    static var all: [SupportedLanguages] {
        return [.ru, .en]
    }
    
    var localizedTitle: String {
        switch self {
        case .ru:
            return "Русский"
        case .en:
            return "English"
        }
    }
}
