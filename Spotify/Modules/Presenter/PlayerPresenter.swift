//
//  PlayerPresenter.swift
//  Spotify
//
//  Created by Aneli  on 06.04.2024.
//

import UIKit
import AVFoundation
import Kingfisher

// MARK: - Protocols

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageUrl: String? { get }
}

// MARK: - PlayerPresenter

final class PlayerPresenter: PlayerViewControllerDelegate {
    
    // MARK: - Properties
    
    static let shared = PlayerPresenter()
    var track: RecommendedMusicData?
    var tracks: [RecommendedMusicData] = []
    private var currentTrackIndex: Int = 0
    private var player: AVPlayer?
    private var queuePlayer: AVQueuePlayer?
    
    // MARK: - PlayerViewControllerDelegate methods
    
    func didTapFavorite() {
        
    }
    
    func didTapBackward() {
        guard currentTrackIndex > 0 else { return }
        currentTrackIndex -= 1
        playCurrentTrack()
    }
    
    func didTapForward() {
        guard currentTrackIndex < tracks.count - 1 else { return }
        currentTrackIndex += 1
        playCurrentTrack()
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
    
    // MARK: - Methods for starting player
    
    func startPlayer(
        from viewController: UIViewController,
        track: RecommendedMusicData
    ) {
        queuePlayer?.pause()
        guard let url = URL(string: track.previewUrl ?? "") else { return }
        self.player = AVPlayer(url: url)
        self.player?.volume = 0.5
        self.track = track
        self.tracks = []
        self.currentTrackIndex = 0
        
        let playerViewController = PlayerViewController(tracks: [track])
        playerViewController.delegate = self
        playerViewController.dataSource = self
                
        playerViewController.modalPresentationStyle = .overFullScreen
        viewController.present(playerViewController, animated: true) { [weak self]  in
            self?.player?.play()
        }
    }
    
    func startPlayer(
        from viewController: UIViewController,
        tracks: [RecommendedMusicData]
    ) {
        player?.pause()
        
        self.tracks = tracks
        self.currentTrackIndex = 0
        
        let playerViewController = PlayerViewController(tracks: tracks)
        playerViewController.delegate = self
        playerViewController.dataSource = self
        
        playerViewController.modalPresentationStyle = .overFullScreen
        viewController.present(playerViewController, animated: true) { [weak self]  in
            self?.startPlayback(tracks: tracks)
        }
    }

    // MARK: - Private Methods
    
    private func startPlayback(tracks: [RecommendedMusicData]) {
        let playerItems: [AVPlayerItem] = tracks.compactMap { track in
            guard let url = URL(string: track.previewUrl ?? "") else { return nil }
            return AVPlayerItem(url: url)
        }
        
        queuePlayer = AVQueuePlayer(items: playerItems)
        queuePlayer?.volume = 0.1
        queuePlayer?.play()
    }
    
    private func playCurrentTrack() {
        guard tracks.indices.contains(currentTrackIndex) else { return }
        let track = tracks[currentTrackIndex]
        guard let url = URL(string: track.previewUrl ?? "") else { return }
        self.player = AVPlayer(url: url)
        self.player?.play()
        
        NotificationCenter.default.post(name: .currentTrackChanged, object: nil)
    }
}

// MARK: - PlayerDataSource

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
    
    private var currentTrack: RecommendedMusicData? {
        guard tracks.indices.contains(currentTrackIndex) else { return nil }
        return tracks[currentTrackIndex]
    }
}

// MARK: - Notification Name Extension

extension Notification.Name {
    static let currentTrackChanged = Notification.Name("currentTrackChanged")
}
