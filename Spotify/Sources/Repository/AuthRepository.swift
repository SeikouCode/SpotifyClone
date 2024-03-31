//
//  AuthRepository.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
//

import KeychainSwift

class AuthRepository: AuthRepositoryProtocol {
    
    private let keychain = KeychainSwift()
    
    private enum Constants {
        static let accessTokenKey = "accessToken"
        static let refreshTokenKey = "refreshToken"
    }
    
    func save(accessToken: String) {
        keychain.set(accessToken, forKey: Constants.accessTokenKey)
    }
    
    func getAccessToken() -> String? {
        return keychain.get(Constants.accessTokenKey)
    }
    
    func removeAccessToken() {
        keychain.delete(Constants.accessTokenKey)
    }
    
    func save(refreshToken: String) {
        keychain.set(refreshToken, forKey: Constants.refreshTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return keychain.get(Constants.refreshTokenKey)
    }
    
    func removeRefreshToken() {
        keychain.delete(Constants.refreshTokenKey)
    }
    
    func removeAllTokens() {
        keychain.delete(Constants.accessTokenKey)
        keychain.delete(Constants.refreshTokenKey)
    }
}
