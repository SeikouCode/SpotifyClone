//
//  PlaylistViewModel.swift
//  Spotify
//
//  Created by Aneli  on 04.04.2024.
//

import Foundation

class PlaylistViewModel {
    
    func getPlaylistDetails(playlistID: String, completion: @escaping (APIResult<PlaylistDetailsResponse>) -> Void) {
        
        AlbumsManager.shared.getPlaylistDetails(playlistID: playlistID) { result in
            switch result {
            case .success(let playlistDetails):
                completion(.success(playlistDetails))
            case .failure(let error):
                let networkError = NetworkError.failedWith(error: error.localizedDescription)
                completion(.failure(networkError))
            }
        }
    }
}
