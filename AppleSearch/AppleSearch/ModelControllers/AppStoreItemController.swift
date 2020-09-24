//
//  AppStoreItemController.swift
//  AppleSearch
//
//  Created by Alex Kennedy on 9/24/20.
//  Copyright © 2020 Alex Kennedy. All rights reserved.
//
// https://itunes.apple.com/search?=term=Jack+Johnson&entity=musicTrack

import Foundation
import UIKit.UIImage

struct StringConstants {
    fileprivate static let baseURLString = "https://itunes.apple.com/"
    fileprivate static let searchComponent = "search"
    fileprivate static let termQueryName = "term"
    fileprivate static let entityQueryName = "entity"
    fileprivate static let musicEntityQueryValue = "musicTrack"
    
    fileprivate static let appEntityQueryValue = "software"
}

class AppStoreItemController {
    
    static func fetchMusicItems(searchTerm: String, completion: @escaping (Result<[MusicTrack], AppleStoreError>) -> Void) {
        guard let baseURL = URL(string: StringConstants.baseURLString) else { return completion(.failure(.invalidURL)) }
        let searchURL = baseURL.appendingPathComponent(StringConstants.searchComponent)
        
        var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        let termQuery = URLQueryItem(name: StringConstants.termQueryName, value: searchTerm)
        let entityQuery = URLQueryItem(name: StringConstants.entityQueryName, value: StringConstants.musicEntityQueryValue)
        
        components?.queryItems = [termQuery, entityQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error { return completion(.failure(.thrownError(error)))}
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelDictionary = try JSONDecoder().decode(MusicTopLevelObject.self, from: data)
                let musicItems = topLevelDictionary.results
                return completion(.success(musicItems))
            } catch {
                return completion(.failure(.unableToDecode(error)))
            }
            
            
        }.resume()
        
        
        
    }
    
    static func fetchAppItems(searchTerm: String, completion: @escaping (Result<[AppItem], AppleStoreError>) -> Void) {
        guard let baseURL = URL(string: StringConstants.baseURLString) else { return completion(.failure(.invalidURL)) }
        let searchURL = baseURL.appendingPathComponent(StringConstants.searchComponent)
        
        var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        let termQuery = URLQueryItem(name: StringConstants.termQueryName, value: searchTerm)
        let entityQuery = URLQueryItem(name: StringConstants.entityQueryName, value: StringConstants.appEntityQueryValue)
        
        components?.queryItems = [termQuery, entityQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error { return completion(.failure(.thrownError(error)))}
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelDictionary = try JSONDecoder().decode(AppTopLevelObject.self, from: data)
                let appItems = topLevelDictionary.results
                return completion(.success(appItems))
            } catch {
                return completion(.failure(.unableToDecode(error)))
            }
            
        }.resume()
        
    }
    
    static func fetchImageFrom(url: URL, completion: @escaping (Result<UIImage, AppleStoreError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error { return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecodeImage)) }
            completion(.success(image))
        }.resume()
    }
}




// func getItemsOf(type: AppStoreItem.ItemType, searchText: String, completion: @escaping (([AppStoreItem]) -> Void)) {
//
//        let baseURL = URL(string: "https://itunes.apple.com/search")!
//        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else
//        {
//            print("URL is not working right")
//            completion([])
//            return
//
//        }
//
//        let searchTermQuery = URLQueryItem(name: "term", value: searchText)
//        let entityQuery = URLQueryItem(name: "entity", value: type.rawValue)
//        components.queryItems = [searchTermQuery, entityQuery]
//
//        guard let url = components.url
//            else { return }
//
//        URLSession.shared.dataTask(with: url) { (data, _, error) in
//            if let error = error {
//                print("Error getting stuff back from Apple")
//                completion([])
//                return
//            }
//            guard let data = data
//                else {
//                print("No data was received from Apple")
//                completion([])
//                return
//            }
//
//            guard let topLevelJSON = (try JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any]
//                else {
//                print("No data was received from Apple")
//                completion([])
//                return
//            }
//        }.resume()
//
//    }
//}
