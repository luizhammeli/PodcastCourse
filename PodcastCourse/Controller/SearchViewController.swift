//
//  SearchViewController.swift
//  PodcastCourse
//
//  Created by iOS Developer on 07/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    var podcasts = [Podcast]()
    
    let cellID = "cellID"
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpSearchController()
    }
   
    //MARK:- TableView
    
    fileprivate func setUpTableView(){
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)        
        cell.textLabel?.text = "\(podcasts[indexPath.item].trackName ?? "")\n\(podcasts[indexPath.item].artistName ?? "")"
        cell.textLabel?.numberOfLines = -1
        cell.imageView?.image = #imageLiteral(resourceName: "icon")
        return cell
    }
    
    //MARK:- SearchBar
   fileprivate func setUpSearchController(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.replacingOccurrences(of: " ", with: "+")
        let url = "https://itunes.apple.com/search?entity=podcast&term=\(text)"

        Alamofire.request(url).responseData { (dataReponse) in

            if let error = dataReponse.error{
                print(error)
            }

            guard let data = dataReponse.data else {return}
            //print(String(data: data, encoding: String.Encoding.utf8) ?? "")
            self.convertJson(data)
        }        
    }
    
    func convertJson(_ data: Data){
        do{
            let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
            podcasts = searchResult.results
            self.tableView.reloadData()
        }catch let error{
            print(error)
        }
    }
}
