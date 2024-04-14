//
//  AllCategoriesResponse.swift
//  Spotify
//
//  Created by Aneli  on 11.04.2024.
//

import Foundation

struct AllCategoriesResponse: Decodable {
    let categories: Categories
}

struct Categories: Decodable {
    let items: [Category]
}

struct Category: Decodable {
    let id: String
    let name: String
    let icons: [ImageDataModel]
}
