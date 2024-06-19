//
//  PlaylistDetailsResponse.swift
//  Spotify
//
//  Created by Aneli  on 04.04.2024.
//

import Foundation

struct PlaylistDetailsResponse: Decodable {
    let album_type: String?
    let description: String?
    let external_urls: [String: String]?
    let id: String?
    let images: [Image]?
    let name: String?
    let tracks: PlaylistTracksResponse
}

struct PlaylistTracksResponse: Decodable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Decodable {
    let track: AudioTrack?
}
