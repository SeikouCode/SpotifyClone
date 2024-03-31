//
//  HomeTarget.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
//

import Foundation
import Moya

enum HomeTarget {
    case getNewReleases
    case getRecommendations(genres: String)
    case getFeaturedPlaylists
    case getRecommendedGenres
}

extension HomeTarget: BaseTargetType {
    var baseURL: URL {
        return URL(string: GlobalConstants.apiBaseURL)!
    }
    
    var path: String {
        switch self {
        case .getNewReleases:
            return "/v1/browse/new-releases"
        case .getRecommendations:
            return "/v1/recommendations"
        case .getFeaturedPlaylists:
            return "/v1/browse/featured-playlists"
        case .getRecommendedGenres:
            return "/v1/recommendations/available-genre-seeds"
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getNewReleases:
            return .requestParameters(parameters: ["limit": 30,"offset": 0],
                                      encoding: URLEncoding.default
            )
        case .getRecommendations(let genres):
            return .requestParameters(parameters: ["seed_genres": genres],
                                      encoding: URLEncoding.default
            )
        case .getFeaturedPlaylists:
            return .requestParameters(parameters: ["limit": 30,"offset": 0],
                                      encoding: URLEncoding.default)
        case .getRecommendedGenres:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var header = [String : String]()
        AuthManager.shared.withValidToken { token in
            header["Authorization"] = "Bearer \(token)"
        }
        return header
    }
}
