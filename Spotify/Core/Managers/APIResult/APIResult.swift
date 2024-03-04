//
//  APIResult.swift
//  Spotify
//
//  Created by Aneli  on 27.02.2024.
//

import Foundation

enum APIResult<T> {
    case success(T)
    case failure(NetworkError)
}
enum NetworkError {
    case networkFail
    case incorrectJSON
    case unknown
    case failedWith(error: String)
}
