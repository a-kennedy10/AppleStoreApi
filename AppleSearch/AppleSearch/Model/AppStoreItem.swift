//
//  AppStoreItem.swift
//  AppleSearch
//
//  Created by Alex Kennedy on 9/24/20.
//  Copyright © 2020 Alex Kennedy. All rights reserved.
//

import Foundation

struct AppTopLevelObject: Codable {
    let results: [AppItem]
}

struct AppItem: Codable {
    let trackName: String
    let artworkUrl100: URL?
    let description: String
}


extension AppStoreItem {
    
    init?(itemType: AppStoreItem.ItemType, dict: [String : Any]) {
        if itemType == .app {
            guard let title = dict["trackName"] as? String,
                let subtitle = dict["description"] as? String else { return nil }
            
            let imageURL = dict["artworkUrl100"] as? String
            
            self.title = title
            self.subtitle = subtitle
            self.imageURL = imageURL
            
        } else if itemType == .song {
            
            guard let title = dict["artistName"] as? String, let subtitle = dict["trackName"] as? String else { return nil }
            
            let imageURL = dict["artworkUrl100"] as? String
            
            self.title = title
            self.subtitle = subtitle
            self.imageURL = imageURL
            
        } else {
            print("forgot to add availability for other types of items")
        }
        return nil
        
    }
}
