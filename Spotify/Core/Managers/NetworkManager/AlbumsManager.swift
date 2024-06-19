//
//  AlbumsManager.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
//

import Foundation
import Moya

final class AlbumsManager {
    static let shared = AlbumsManager()
    
    private let provider = MoyaProvider<HomeTarget>(
        plugins: [
            NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
            LoggerPlugin()
        ]
    )
    
    func getNewReleases(completion: @escaping (APIResult<[NewReleasesAlbum]>) -> Void) {
        provider.request(.getNewReleases) { result in
            switch result {
            case .success(let response):
                guard let dataModel = try? JSONDecoder().decode(NewReleasesResponse.self, from: response.data) else { return }
                completion(.success(dataModel.albums.items))
                case .failure(let error):
                    print("Failed to get new releases:", error)
                        break
            }
        }
    }
    
    func getFeaturedPlaylists(completion: @escaping (APIResult<[FeaturedPlaylists]>) -> Void) {
        provider.request(.getFeaturedPlaylists) { result in
            switch result {
            case .success(let response):
                do {
                    let dataModel = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: response.data)
                    completion(.success(dataModel.playlists.items))
                } catch {
                    print("Error decoding featured playlists response:", error)
                    completion(.failure(.incorrectJSON))
                }
                case .failure(let error):
                    print("Failed to get featured playlists:", error)
                        break
            }
        }
    }
    
    func getRecommendations(genres: String, completion: @escaping (APIResult<[Track]>) -> Void) {
        provider.request(.getRecommendations(genres: genres)) { result in
            switch result {
            case .success(let response):
                do {
                    let dataModel = try JSONDecoder().decode(RecommendedGenresResponse.self, from: response.data)
                    completion(.success(dataModel.tracks))
                } catch {
                    print("Error decoding recommendations response:", error)
                    completion(.failure(.incorrectJSON))
                }
            case .failure(let error):
                print("Failed to get recommendations:", error)
                    break
            }
        }
    }
    
    func getRecommendedGenres(completion: @escaping (Result<[String], Error>) -> Void) {
        provider.request(.getRecommendedGenres) { result in
            switch result {
            case .success(let response):
                do {
                    let genres = try JSONDecoder().decode(RecommendedDataModel.self, from: response.data)
                    completion(.success(genres.genres))
                } catch {
                    print("Error decoding recommended genres response:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Failed to get recommended genres:", error)
                completion(.failure(error))
            }
        }
    }
    
    func getAlbumDetails(albumsID: String, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        provider.request(.getAlbumDetails(albumId: albumsID)) { result in
            switch result {
            case .success(let response):
                do {
                    let dataModel = try JSONDecoder().decode(AlbumDetailsResponse.self, from: response.data)
                    completion(.success(dataModel))
                } catch {
                    print("Error decoding album details response:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Failed to get album details:", error)
                completion(.failure(error))
            }
        }
    }
    
    func getPlaylistDetails(playlistID: String, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        provider.request(.getPlaylistDetails(playlistID: playlistID)) { result in
            switch result {
            case .success(let response):
                do {
                    let dataModel = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: response.data)
                    completion(.success(dataModel))
                } catch {
                    print("Error decoding playlist details response:", error)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Failed to get playlist details:", error)
                completion(.failure(error))
            }
        }
    }
}
