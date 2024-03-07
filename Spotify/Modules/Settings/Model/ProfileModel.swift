//
//  ProfileModel.swift
//  Spotify
//
//  Created by Aneli  on 04.03.2024.
//

import Foundation

// MARK: - ProfileModel
struct ProfileModel: Codable {
    let displayName: String
    let externalUrls: ExternalUrls
    let email: String
    let href: String
    let id: String
    let images: [Image]
    let type, uri: String
    let followers: Followers
    let country: String
    let product: String
    let explicitContent: ExplicitContent?

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case email
        case externalUrls = "external_urls"
        case href, id, images, type, uri, followers, country, product
        case explicitContent = "explicit_content"
    }
}

// MARK: - ExplicitContent
struct ExplicitContent: Codable {
    let filterEnabled, filterLocked: Bool

    enum CodingKeys: String, CodingKey {
        case filterEnabled = "filter_enabled"
        case filterLocked = "filter_locked"
    }
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String
}

// MARK: - Followers
struct Followers: Codable {
    let href: JSONNull?
    let total: Int
}

// MARK: - Image
struct Image: Codable {
    let url: String
    let height, width: Int
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
