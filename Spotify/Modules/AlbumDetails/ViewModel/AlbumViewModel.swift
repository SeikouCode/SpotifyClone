//
//  AlbumViewModel.swift
//  Spotify
//
//  Created by Aneli  on 04.04.2024.
//

final class AlbumViewModel {
    
    private func getAlbumDetails(albumId: String, completion: @escaping (APIResult<AlbumDetails>) -> Void) {
        
        AlbumsManager.shared.getAlbumDetail(albumsID: albumId) { result in
            switch result {
            case .success(let albumDetails):
                completion(.success(albumDetails))
            case .failure(let error):
                let networkError = NetworkError.failedWith(error: error.localizedDescription)
                completion(.failure(networkError))
            }
        }
    }
}
