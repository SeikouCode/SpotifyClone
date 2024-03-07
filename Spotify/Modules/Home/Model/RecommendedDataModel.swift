//
//  RecommendedDataModel.swift
//  Spotify
//
//  Created by Aneli  on 06.03.2024.
//

    import Foundation

    // MARK: - RecommendedDataModel
    struct RecommendedDataModel {
//        let albums: Albums
    }

//    // MARK: - Albums
//    struct Albums: Codable {
//        let href: String
//        let items: [Item]
//        let limit: Int
//        let next: JSONNull?
//        let offset: Int
//        let previous: JSONNull?
//        let total: Int
//    }
//
//    // MARK: - Item
//    struct Item: Codable {
//        let albumType: String
//        let artists: [Artist]
//        let availableMarkets: [String]
//        let externalUrls: ExternalUrls
//        let href: String
//        let id: String
//        let images: [Image]
//        let name, releaseDate, releaseDatePrecision: String
//        let totalTracks: Int
//        let type, uri: String
//
//        enum CodingKeys: String, CodingKey {
//            case albumType = "album_type"
//            case artists
//            case availableMarkets = "available_markets"
//            case externalUrls = "external_urls"
//            case href, id, images, name
//            case releaseDate = "release_date"
//            case releaseDatePrecision = "release_date_precision"
//            case totalTracks = "total_tracks"
//            case type, uri
//        }
//    }
//
//    // MARK: - Artist
//    struct Artist: Codable {
//        let externalUrls: ExternalUrls
//        let href: String
//        let id, name, type, uri: String
//
//        enum CodingKeys: String, CodingKey {
//            case externalUrls = "external_urls"
//            case href, id, name, type, uri
//        }
//    }
//
//    // MARK: - ExternalUrls
//    struct ExternalUrls: Codable {
//        let spotify: String
//    }
//
//    // MARK: - Image
//    struct Image: Codable {
//        let height: Int
//        let url: String
//        let width: Int
//    }
//
//    // MARK: - Encode/decode helpers
//
//    class JSONNull: Codable, Hashable {
//
//        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//            return true
//        }
//
//        public var hashValue: Int {
//            return 0
//        }
//
//        public init() {}
//
//        public required init(from decoder: Decoder) throws {
//            let container = try decoder.singleValueContainer()
//            if !container.decodeNil() {
//                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//            }
//        }
//
//        public func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            try container.encodeNil()
//        }
//    }
//}
