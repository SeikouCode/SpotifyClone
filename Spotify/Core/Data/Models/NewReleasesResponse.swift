//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
//

import Foundation

// MARK: - NewReleasesResponse

struct NewReleasesResponse: Decodable {
    let albums: AlbumsDataModel
}

// MARK: - AlbumsDataModel

struct AlbumsDataModel: Decodable {
    let items: [NewReleasesAlbum]
}

struct NewReleasesAlbum: Decodable {
    let id: String?
    let totalTracks: Int?
    let albumType: String?
    let artists: [Artists]
    let availableMarkets: [String]
    let type: String?
    let images: [ImageDataModel]
    let releaseDate: String?
    let externalUrls: [String: String]?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case totalTracks = "total_tracks"
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case type
        case images
        case releaseDate = "release_date"
        case externalUrls = "external_urls"
        case name
    }
}

// MARK: - Artists

struct Artists: Decodable {
    let id: String?
    let externalUrls: [String: String]?
    let name: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case externalUrls = "external_urls"
        case name
        case type
    }
}

struct ImageDataModel: Decodable {
    let url: String
}
