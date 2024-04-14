//
//  PlayerPresenter.swift
//  Spotify
//
//  Created by Aneli  on 06.04.2024.
//

import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageUrl: String? { get }
}

final class PlayerPresenter: PlayerViewControllerDelegate {
    func didTapBackward() {
        
    }
    
    func didTapForward() {
        
    }
    
    func didTapPlayAndPause() {
        if let player = self.player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        
        if let queuePlayer = self.queuePlayer {
            if queuePlayer.timeControlStatus == .playing {
                queuePlayer.pause()
            } else if queuePlayer.timeControlStatus == .paused {
                queuePlayer.play()
            }
        }
    }
    
    static let shared = PlayerPresenter()
    private var track: RecommendedMusicData?
    private var tracks: [RecommendedMusicData] = []
    private var player: AVPlayer?
    private var queuePlayer: AVQueuePlayer?
    
    private var currentTrack: RecommendedMusicData? {
        if let track, tracks.isEmpty {
            return track
        } else if !tracks.isEmpty {
            return tracks.first
        }
        return nil
    }
    
    func startPlayer(
        from viewController: UIViewController,
        track: RecommendedMusicData
    ) {
        queuePlayer?.pause()
        guard let url = URL(string: track.previewUrl ?? "") else { return }
        self.player = AVPlayer(url:  url)
        self.player?.volume = 0.5
        self.track = track
        self.tracks = []
        let viewController = PlayerViewController()
        viewController.delegate = self
        viewController.dataSource = self
        viewController.modalPresentationStyle = .overFullScreen
        viewController.present(viewController, animated: true) { [weak self]  in
            self?.player?.play()
        }
    }
    
    func startPlayer(
        from viewController: UIViewController,
        tracks: [RecommendedMusicData]
    ) {
        player?.pause()
        
        let playerItems: [AVPlayerItem] = tracks.compactMap { track in
            guard let url = URL(string: track.previewUrl ?? "") else { return nil }
            return AVPlayerItem(url: url)
        }
        
        queuePlayer = AVQueuePlayer(items: playerItems)
        queuePlayer?.volume = 0.1
        self.track = nil
        self.tracks = tracks
        let playerViewController = PlayerViewController()
        playerViewController.delegate = self
        playerViewController.dataSource = self
        playerViewController.modalPresentationStyle = .overFullScreen
        viewController.present(playerViewController, animated: true) { [weak self]  in
            self?.queuePlayer?.play()
        }
    }
}

extension PlayerPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.title
    }
    
    var subtitle: String? {
        return currentTrack?.subtitle
    }
    
    var imageUrl: String? {
        return currentTrack?.image
    }
}
