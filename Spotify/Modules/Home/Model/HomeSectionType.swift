//
//  HomeSectionType.swift
//  Spotify
//
//  Created by Aneli  on 06.03.2024.
//

import Foundation

enum HomeSectionType {
    case newRelesedAlbums(datamodel: [PlaylistDataModel])
    case featuredPlaylists(datamodel: [PlaylistDataModel])
    case recommended(datamodel: [RecommendedDataModel])
}
