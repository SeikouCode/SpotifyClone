//
//  GlobalConstants.swift
//  Spotify
//
//  Created by Aneli  on 27.02.2024.
//

import Foundation

enum GlobalConstants {
    static let baseURL = "https://accounts.spotify.com"
    
    struct AuthAPI {
        static let clientId = "773dcf457e944a6599986eb21c7b4f7a"
        static let clientSecret = "e87b3070700f4557a82a9962afa2eb7b"
        static let redirectUri = "https://open.spotify.com/"
        static let scopes = Scopes.allScopes.joined(separator: "%20")
    }
    
    enum Scopes {
        static let userReadPlaybackState = "user-read-playback-state"
        static let userReadEmail = "user-read-email"
        static let userFollowRead = "user-follow-read"
        static let userLibraryModify = "user-library-modify"
        static let playlistDodifyPublic = "playlist-modify-public"
        static let playlistModifyPrivate = "playlist-modify-private"
        
        static let allScopes = [
            userReadPlaybackState,
            userReadEmail,
            userFollowRead,
            userLibraryModify,
            playlistDodifyPublic,
            playlistModifyPrivate
        ]
    }
}
