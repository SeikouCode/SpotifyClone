//
//  CategoryManager.swift
//  Spotify
//
//  Created by Aneli  on 11.04.2024.
//

import Foundation
import Moya

final class CategoryManager {
    static let shared = CategoryManager()
    
    private let provider = MoyaProvider<CategoryTarget>(
        plugins: [
            NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
            LoggerPlugin()
        ]
    )
    
    func getCategories(completion: @escaping (APIResult<[Category]>) -> Void) {
        provider.request(.getCategories) { result in
            switch result {
            case .success(let response):
                do {
                    let categories = try JSONDecoder().decode(AllCategoriesResponse.self, from: response.data)
                    completion(.success(categories.categories.items))
                } catch {
                    completion(.failure(.unknown))
                }
            case .failure(_):
                completion(.failure(.networkFail))
            }
        }
    }
    
    func getCategoryPlaylist(category: Category, completion: @escaping (APIResult<[FeaturedPlaylists]>) -> ()) {
        provider.request(.getCategoryPlaylist(id: category.id)) { result in
            switch result {
            case .success(let response):
                guard let dataModel = try? JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: response.data) else { return }
                completion(.success(dataModel.playlists.items))
            case .failure(let error):
                break
            }
        }
    }
}
