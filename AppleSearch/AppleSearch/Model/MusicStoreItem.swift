//
//  MusicStoreItem.swift
//  AppleSearch
//
//  Created by Alex Kennedy on 9/24/20.
//  Copyright © 2020 Alex Kennedy. All rights reserved.
//

import Foundation


struct MusicTopLevelObject: Codable {
    let results: [MusicTrack]
    
}

struct MusicTrack: Codable {
    let artistName: String
    let trackName: String
    let artworkUrl100: URL?
}
