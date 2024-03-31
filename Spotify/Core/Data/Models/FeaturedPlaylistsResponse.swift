//
//  FeaturedPlaylistsResponse.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
//

import Foundation

// MARK: - FeaturedPlaylistsResponse

struct FeaturedPlaylistsResponse: Decodable {
    let playlists: PlaylistResponse
}

// MARK: - PlaylistResponse

struct PlaylistResponse: Decodable {
    let items: [FeaturedPlaylists]
}

// MARK: - FeaturedPlaylists

struct FeaturedPlaylists: Decodable {
    let name: String?
    let description: String?
    let id: String?
    let externalUrls: [String: String]?
    let images: [ImageDataModel]?
    let owner: User?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case id
        case externalUrls = "external_urls"
        case images
        case owner
    }
}

// MARK: - User

struct User: Decodable {
    let id: String?
    let displayName: String?
    let externalUrls: [String: String]?
    
    enum CodingKeys: String,CodingKey {
        case id
        case displayName = "display_name"
        case externalUrls = "external_urls"
    }
}
