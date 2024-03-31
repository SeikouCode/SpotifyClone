//
//  RecommendedGenresResponse.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
//

import Foundation

// MARK: - RecommendedGenresResponse

struct RecommendedGenresResponse: Decodable {
    let tracks: [Track]
    let seeds: [Seed]
}

// MARK: - Seed

struct Seed: Decodable {
    let initialPoolSize, afterFilteringSize, afterRelinkingSize: Int
    let id, type: String
    let href: String?
}

// MARK: - Track

struct Track: Decodable {
    let album: Playlists?
    let artists: [Artist]?
    let availableMarkets: [String]?
    let discNumber, durationMS: Int?
    let href: String?
    let id, name: String?
    let popularity: Int?
    let previewURL: String?
    let trackNumber: Int?
    let isLocal: Bool?
    
    enum CodingKeys: String, CodingKey {
        case artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case href, id, name, popularity
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case isLocal = "is_local"
        case album
    }
}
// MARK: - Playlists

struct Playlists: Decodable {
    let description: String?
    let external_urls: [String: String]?
    let id: String?
    let images: [Image]?
    let name: String?
    let owner: User?
}

// MARK: - Artist

struct Artist: Decodable {
    let externalUrls: ExternalUrls
    let href, id, name, type: String
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}
