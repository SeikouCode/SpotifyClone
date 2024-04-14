//
//  SearchResponse.swift
//  Spotify
//
//  Created by Aneli  on 11.04.2024.
//

import Foundation

struct SearchResponse: Decodable {
    let tracks: SearchTrackResponse
}

struct SearchTrackResponse: Decodable {
    let items: [AudioTrack]
}
