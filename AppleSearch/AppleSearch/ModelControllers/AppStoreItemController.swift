//
//  AppStoreItemController.swift
//  AppleSearch
//
//  Created by Alex Kennedy on 9/24/20.
//  Copyright © 2020 Alex Kennedy. All rights reserved.
//

import Foundation

class AppStoreItemController {
    static func getItemsOf(type: AppStoreItem.ItemType, searchText: String, completion: @escaping (([AppStoreItem]) -> Void)) {
        
        let baseURL = URL(string: "https://itunes.apple.com/search")!
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else
        {
            print("URL is not working right")
            completion([])
            return
            
        }
        
        let searchTermQuery = URLQueryItem(name: "term", value: searchText)
        let entityQuery = URLQueryItem(name: "entity", value: type.rawValue)
        components.queryItems = [searchTermQuery, entityQuery]
        
        guard let url = components.url
            else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error getting stuff back from Apple")
                completion([])
                return
            }
            guard let data = data
                else {
                print("No data was received from Apple")
                completion([])
                return
            }
            
            guard let topLevelJSON = (try JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any]
                else {
                print("No data was received from Apple")
                completion([])
                return
            }
        }.resume()
        
    }
}

