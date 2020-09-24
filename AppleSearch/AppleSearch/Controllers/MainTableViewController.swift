//
//  MainTableViewController.swift
//  AppleSearch
//
//  Created by Alex Kennedy on 9/24/20.
//  Copyright © 2020 Alex Kennedy. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    //MARK: - outlets
    @IBOutlet weak var itemSearchBar: UISearchBar!
    @IBOutlet weak var itemSegmentedController: UISegmentedControl!
    
    //MARK: - properties
    var musicItems: [MusicTrack] = []
    var appItems: [AppItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemSearchBar.delegate = self
    }
    
   
    //MARK: - actions
    @IBAction func entitySegmentedControlSwitch(_ sender: Any) {
        search()
    }
    
    //MARK: - helpers
       func search() {
           guard let searchTerm = itemSearchBar.text, !searchTerm.isEmpty else { return }
           
           if itemSegmentedController.selectedSegmentIndex == 0 {
               AppStoreItemController.fetchMusicItems(searchTerm: searchTerm) { (result) in
                   switch result {
                       
                   case .success(let musicTracks):
                       self.musicItems = musicTracks
                       DispatchQueue.main.async {
                           self.tableView.reloadData()
                       }
                       
                   case .failure(let error):
                       print(error.localizedDescription)
                   }
               }
               
               
           } else {
               AppStoreItemController.fetchAppItems(searchTerm: searchTerm) { (result) in
                   switch result {
                       
                   case .success(let apps):
                       self.appItems = apps
                       DispatchQueue.main.async {
                           self.tableView.reloadData()
                       }
                   case .failure(let error):
                       print(error.localizedDescription)
                   }
               }
           }
       }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch itemSegmentedController.selectedSegmentIndex {
            
        case 0:
            return self.musicItems.count
        case 1:
            return self.appItems.count
        default:
            return 0
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entityCell", for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
        
        switch itemSegmentedController.selectedSegmentIndex {
        case 0:
            let track = musicItems[indexPath.row]
            cell.musicTrack = track
            cell.appItem = nil
        case 1:
            let app = appItems[indexPath.row]
            cell.appItem = app
            cell.musicTrack = nil
        default:
            break
        }
        cell.updateViews()
        
        return cell
    }
}


extension MainTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
}
