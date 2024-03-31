//
//  Localizer.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
//

import Foundation

extension Bundle {
    private static var bundle: Bundle?
    
    public static func localizedBundle() -> Bundle? {
        if bundle == nil {
            let appLang = UserDefaults.standard.string(forKey: "AppLanguage") ?? "ru"
            let path = Bundle.main.path(forResource: appLang, ofType: "lproj")
            guard let path else { return nil }
            bundle = Bundle(path: path)
        }
        return bundle
    }
    
    public static func setLanguage(language: String) {
        UserDefaults.standard.set(language, forKey: "AppLanguage")
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        guard let path else { return }
        bundle = Bundle(path: path)
    }
}
