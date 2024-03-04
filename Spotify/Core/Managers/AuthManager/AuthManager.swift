//
//  AuthManager.swift
//  Spotify
//
//  Created by Aneli  on 17.02.2024.
//

import Foundation
import Moya
import KeychainSwift

final class AuthManager {
    static let shared = AuthManager()
    
// MARK: - Properties
    
    private let provider = MoyaProvider<AuthTarget>(
        plugins: [
            NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
            LoggerPlugin()
        ]
    )
    
    private var refreshingToken = false
    private var onRefreshBlocks = [(String) -> Void]()
    private let keychain = KeychainSwift()
    
// MARK: - Computed Properties
    
    public var signInURL: URL? {
        let baseURL = GlobalConstants.baseURL + "/authorize"
        var components = URLComponents(string: baseURL)
        
        components?.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: GlobalConstants.AuthAPI.clientId),
            URLQueryItem(name: "scope", value: GlobalConstants.AuthAPI.scopes),
            URLQueryItem(name: "redirect_uri", value: GlobalConstants.AuthAPI.redirectUri),
            URLQueryItem(name: "show_dialog", value: "TRUE"),
        ]
        
        return components?.url
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
// MARK: - Initializer
    
    private init() {}
    
// MARK: - Private Properties
    
    private var accessToken: String? {
        get {
            return keychain.get("accessToken")
        }
        set {
            if let newValue = newValue {
                keychain.set(newValue, forKey: "accessToken")
            } else {
                keychain.delete("accessToken")
            }
        }
    }
    
    private var refreshToken: String? {
        get {
            return keychain.get("refreshToken")
        }
        set {
            if let newValue = newValue {
                keychain.set(newValue, forKey: "refreshToken")
            } else {
                keychain.delete("refreshToken")
            }
        }
    }
    
    private var tokenExpirationDate: Date? {
        get {
            if let dateString = keychain.get("expirationDate"), let date = ISO8601DateFormatter().date(from: dateString) {
                return date
            }
            return nil
        }
        set {
            if let newValue = newValue {
                keychain.set(ISO8601DateFormatter().string(from: newValue), forKey: "expirationDate")
            } else {
                keychain.delete("expirationDate")
            }
        }
    }
    
    private var shouldRefreshToken: Bool {
        guard let tokenExpirationDate = tokenExpirationDate else { return false }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= tokenExpirationDate
    }
    
// MARK: - Public Methods
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((APIResult<Void>) -> ())
    ) {
        provider.request(.getAccessToken(code: code)) { [weak self] result in
            switch result {
            case .success(let response):
                guard let result = try? response.map(AuthResponse.self) else {
                    completion(.failure(.incorrectJSON))
                    return
                }
                self?.cacheToken(result: result)
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(.failedWith(error: error.localizedDescription)))
            }
        }
    }
    
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            refreshAccessToken { [weak self] success in
                if success, let accessToken = self?.accessToken {
                    completion(accessToken)
                }
            }
        } else {
            guard let accessToken else { return }
            completion(accessToken)
        }
    }
    
    public func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        refreshingToken = true
        
        guard let refreshToken else { return }
        provider.request(.refreshToken(token: refreshToken)) { [weak self] result in
            self?.refreshingToken = false
            
            switch result {
            case .success(let response):
                do {
                    let result = try JSONDecoder().decode(AuthResponse.self, from: response.data)
                    print("Successfully refreshed")
                    self?.cacheToken(result: result)
                    self?.onRefreshBlocks.forEach { $0(result.accessToken) }
                    self?.onRefreshBlocks.removeAll()
                    completion(true)
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    public func signOut(completion: @escaping (Bool) -> Void) {
        accessToken = nil
        refreshToken = nil
        tokenExpirationDate = nil
        refreshAccessToken { success in
            completion(success)
    }
}
    
// MARK: - Private Methods

    private func cacheToken(result: AuthResponse) {
        accessToken = result.accessToken
        
        if let refreshToken = result.refreshToken {
            self.refreshToken = refreshToken
        }
        
        tokenExpirationDate = Date().addingTimeInterval(TimeInterval(result.expiresIn))
    }
}
