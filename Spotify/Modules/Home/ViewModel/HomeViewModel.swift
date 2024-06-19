//
//  HomeViewModel.swift
//  Spotify
//
//  Created by Aneli  on 15.02.2024.
//

import UIKit

class HomeViewModel {
    
    // MARK: - Properties
    
    private var sections = [HomeSectionType]()
    private var dispatchGroup = DispatchGroup()
    
    var numberOfSections: Int {
        return sections.count
    }
    
    // MARK: - Public Methods
    
    func getSectionViewModel(at section: Int) -> HomeSectionType {
        return sections[section]
    }
    
    func didLoad(completion: @escaping () -> ()) {
        sections.append(.newReleasedAlbums(title: "New_released_albums".localized, datamodel: []))
        sections.append(.featuredPlaylists(title: "Featured_playlists".localized, datamodel: []))
        sections.append(.recommended(title: "Recommended".localized, datamodel: []))
        
        dispatchGroup.enter()
        loadAlbums(completion: { [weak self] in
            self?.dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        loadPlaylists(completion: { [weak self] in
            self?.dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        loadRecommended(completion: { [weak self] in
            self?.dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func setupSectionTitles() {
        for index in 0..<sections.count {
            switch sections[index] {
            case .newReleasedAlbums(_, let dataModel):
                sections[index] = .newReleasedAlbums(title: "New_released_albums".localized, datamodel: dataModel)
            case .featuredPlaylists(_ , let datamodel):
                sections[index] = .featuredPlaylists(title: "Featured_playlists".localized, datamodel: datamodel)
            case .recommended(_, let datamodel):
                sections[index] = .recommended(title: "Recommended".localized, datamodel: datamodel)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func loadAlbums(completion: @escaping () -> ()) {
        var albums: [AlbumsData] = []
        
        AlbumsManager.shared.getNewReleases { [weak self] result in
            switch result {
            case .success(let response):
                response.forEach {
                    albums.append(
                        .init (
                            id: $0.id,
                            title: $0.name,
                            image: $0.images.first?.url
                        )
                    )
                }
                if let index = self?.sections.firstIndex(where: {
                    if case .newReleasedAlbums = $0 {
                        return true
                    } else {
                        return false
                    }
                }) {
                    self?.sections[index] = .newReleasedAlbums(title: "New_released_albums".localized, datamodel: albums)
                }
                completion()
            case .failure(_):
                break
            }
        }
    }
   
    private func loadPlaylists(completion: @escaping () -> ()) {
        var playlists: [AlbumsData] = []
        
        AlbumsManager.shared.getFeaturedPlaylists { [weak self] result in
            switch result {
            case .success(let dataModel):
                playlists = dataModel.compactMap { item in
                    .init(
                        id: item.id,
                        title: item.name,
                        image: item.images?.first?.url
                    )
                }
                
                if let index = self?.sections.firstIndex(where: {
                    if case .featuredPlaylists = $0 {
                        return true
                    } else {
                        return false
                    }
                }) {
                    self?.sections[index] = .featuredPlaylists(title: "Featured_playlists".localized, datamodel: playlists)
                }
                completion()
            case .failure(_):
                break
            }
        }
    }

    func loadRecommended(completion: @escaping () -> Void) {
        AlbumsManager.shared.getRecommendedGenres { [weak self] result in
            switch result {
            case .success(let genres):
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                let seedsGenres = seeds.joined(separator: ",")
                
                AlbumsManager.shared.getRecommendations(genres: seedsGenres) { [weak self] (result: APIResult<[Track]>) in
                    switch result {
                    case .success(let tracks):
                        print("Received recommended tracks:", tracks)
                        let recommendedMusicData = tracks.map { track in
                            return RecommendedMusicData(title: track.name ?? "", subtitle: track.artists?.first?.name ?? "", image: track.album?.images?.first?.url ?? "", previewUrl: "", id: "")
                        }
                        if let index = self?.sections.firstIndex(where: {
                            if case .recommended = $0 {
                                return true
                            } else {
                                return false
                            }
                        }) {
                            self?.sections[index] = .recommended(title: "Recommended".localized, datamodel: recommendedMusicData)
                        }
                        completion()
                    case .failure(let error):
                        print("Failed to load recommended tracks:", error)
                        completion()
                    }
                }
            case .failure(let error):
                print("Failed to load recommended genres:", error.localizedDescription)
                completion()
            }
        }
    }
}
