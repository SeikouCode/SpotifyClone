//
//  PlayerViewModel.swift
//  Spotify
//
//  Created by Aneli  on 14.05.2024.
//

import Foundation
import AVFoundation

struct TrackPlayerViewModel {
    func getTrackDetails(id: String, completion: @escaping (URL?) -> () ) {
        TrackDetailsManager.shared.getTrackDetails(id: id) { result in
            switch result {
            case .success(let response):
                if let urlString = response.previewUrl, let url = URL(string: urlString) {
                    completion(url)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
