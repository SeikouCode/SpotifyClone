//
//  CategoryTarget.swift
//  Spotify
//
//  Created by Aneli  on 11.04.2024.
//

import Foundation
import Moya

enum CategoryTarget {
    case getCategories
    case getCategoryPlaylist(id: String)
}

extension CategoryTarget: BaseTargetType {
    var baseURL: URL {
        return URL(string: GlobalConstants.apiBaseURL)!
    }
    
    var path: String {
        switch self {
        case .getCategories:
            return "/v1/browse/categories"
        case .getCategoryPlaylist(let id):
            return "/v1/browse/categories/\(id)/playlists"
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCategories:
            return .requestParameters(
                parameters: [
                    "limit": 30,
                    "offset": 0
                ],
                encoding: URLEncoding.default
            )
        case .getCategoryPlaylist:
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
