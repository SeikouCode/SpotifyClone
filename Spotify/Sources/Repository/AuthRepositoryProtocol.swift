//
//  AuthRepositoryProtocol.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
//

import Foundation

protocol AuthRepositoryProtocol {
    func save(accessToken: String)
    func getAccessToken() -> String?
    func removeAccessToken()
    
    func save(refreshToken: String)
    func getRefreshToken() -> String?
    func removeRefreshToken()
    func removeAllTokens()
}
