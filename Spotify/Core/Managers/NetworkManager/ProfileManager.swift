//
//  ProfileManager.swift
//  Spotify
//
//  Created by Aneli  on 04.03.2024.
//

import Foundation
import Moya

final class ProfileManager {
    static let shared = ProfileManager()
    
    private let provider = MoyaProvider<ProfileTargetType>(
        plugins: [
            NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
            LoggerPlugin()
        ]
    )
    
    func getCurrentUserProfile(completion: @escaping (ProfileModel) -> Void) {
        provider.request(.getProfileInfo) { result in
            switch result {
            case .success(let response):
                do {
                    let profile = try JSONDecoder().decode(ProfileModel.self, from: response.data)
                    completion(profile)
                } catch {
                    print("Error decoding profile: \(error)")
                }
            case .failure(let error):
                print("Error getting profile: \(error)")
            }
        }
    }
}
