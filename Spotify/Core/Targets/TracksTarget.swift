//
//  TracksTarget.swift
//  Spotify
//
//  Created by Aneli  on 14.05.2024.
//

import Foundation
import Moya

enum TrackTarget {
    case getTrackDetails(id: String)
    
}

extension TrackTarget: BaseTargetType {
    var baseURL: URL {
        return URL(string: GlobalConstants.apiBaseURL)!
    }
    
    var path: String {
        switch self {
        case .getTrackDetails(let id):
            return "/v1/tracks/\(id)"
        }
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        var header = [String: String]()
        AuthManager.shared.withValidToken { token in
            header["Authorization"] = "Bearer \(token)"
        }
        return header
    }
}
