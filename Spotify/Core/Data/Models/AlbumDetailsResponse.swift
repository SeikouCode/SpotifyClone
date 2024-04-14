//
//  AlbumDetailsResponse.swift
//  Spotify
//
//  Created by Aneli  on 04.04.2024.
//

import Foundation

struct AlbumDetailsResponse: Decodable {
        let album_type: String?
        let artists: [Artist]?
        let available_markets: [String]?
        let external_urls: [String: String]?
        let id: String?
        let description: String?
        let images: [Image]?
        let label: String?
        let name: String?
        let tracks: TracksResponse
        let popularity: Int?
}

struct TracksResponse: Decodable {
    let items: [AudioTrack]?
}
