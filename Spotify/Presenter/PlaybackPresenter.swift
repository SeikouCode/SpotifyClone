//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Aneli  on 06.04.2024.
//

import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageUrl: URL? { get }
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    private var track: RecommendedMusicData?
    private var tracks: [RecommendedMusicData] = []
    
    var player: AVPlayer?
    
    var currentTrack: RecommendedMusicData? {
        if let track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty {
            return tracks.first
        }
        return nil
    }
    
    func startPlayback(
        from viewController: UIViewController,
        track: RecommendedMusicData
    ) {
//        guard let url = URL(string: "https://p.scdn.co/mp3-preview/81b57845f672fa5a0af749489e311ffb9fd552fe?cid=e7346e807b164345b11b96ca9d8fd61d") else {
//            return
//        }
        guard let url = URL(string: track.previewUrl ?? "") else { return }
        self.player = AVPlayer(url:  url)
        self.player?.volume = 0.5
         
        self.track = track
        let viewController = PlayerViewController()
        viewController.dataSource = self
        viewController.present(viewController, animated: true) { [weak self]  in
            self?.player?.play()
        }
    }
    
    func startPlayback(
        from viewController: UIViewController
//        album: Album
    ) {
        let viewController = PlayerViewController()
        viewController.present(viewController, animated: true, completion: nil)
    }
    
    func startPlayback(
        from viewController: UIViewController,
        playlist: [AudioTrack]
    ) {
        let viewController = PlayerViewController()
        viewController.present(viewController, animated: true, completion: nil)
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return nil
    }
    
    var subtitle: String? {
        return nil
    }
    
    var imageUrl: URL? {
        return nil
    }
}
