//
//  SectionModel.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
//

import Foundation

struct Section {
    let title: String
    let rows: [Row]
}

struct Row {
    let title: String
    let handler: () -> Void
}
