//
//  ItemTableViewCell.swift
//  AppleSearch
//
//  Created by Alex Kennedy on 9/24/20.
//  Copyright © 2020 Alex Kennedy. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    //MARK: - outlets
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemSubtitleLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    //MARK: - properties
    var musicTrack: MusicTrack?
    var appItem: AppItem?
    
    
    //MARK: - helpers
    func updateViews() {
        var url: URL?
        
        if let musicTrack = musicTrack {
            itemTitleLabel.text = musicTrack.trackName
            itemSubtitleLabel.text = musicTrack.artistName
            url = musicTrack.artworkUrl100
        } else if let appItem = appItem {
            itemTitleLabel.text = appItem.trackName
            itemSubtitleLabel.text = appItem.description
            url = appItem.artworkUrl100
        }
        
        self.itemImageView.image = nil
        if let url = url {
            AppStoreItemController.fetchImageFrom(url: url) { (result) in
                switch result {
                    
                case .success(let image):
                    DispatchQueue.main.async {
                        self.itemImageView.image = image
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
