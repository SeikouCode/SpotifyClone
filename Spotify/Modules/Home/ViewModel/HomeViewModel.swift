//
//  HomeViewModel.swift
//  Spotify
//
//  Created by Aneli  on 15.02.2024.
//

import UIKit
 
class HomeViewModel {
    private lazy var items: [RecommendedMusicData] = []
    
    var numberOfCells: Int {
        return items.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> RecommendedMusicData {
        return items[indexPath.row]
    }
    
    func loadRecommendedMusics(comletion: () -> ()) {
        let musics: [RecommendedMusicData] = [
            .init(
                title: "Cozy Coffeehouse",
                subtitle: nil,
                image: UIImage(named: "music1") ?? UIImage()
            ),
            .init(
                title: "Cozy",
                subtitle: "Profile",
                image: UIImage(named: "music2") ?? UIImage()
            ),
            .init(
                title: "cozy clouds",
                subtitle: nil,
                image: UIImage(named: "music3") ?? UIImage()
            )
        ]
        
        self.items = musics
        comletion()
    }
}
