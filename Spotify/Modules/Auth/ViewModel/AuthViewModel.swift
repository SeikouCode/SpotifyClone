//
//  AuthViewModel.swift
//  Spotify
//
//  Created by Aneli  on 24.02.2024.
//

import Foundation

class AuthViewModel {
    func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        AuthManager.shared.exchangeCodeForToken(code: code) { result in
            switch result {
            case.success:
                    completion(true)
            case.failure:
                    completion(false)
            }
        }
    }
}
