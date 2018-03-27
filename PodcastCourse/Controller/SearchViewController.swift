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
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpSearchController()
    }
   
    //MARK:- TableView
    
    fileprivate func setUpTableView(){
        self.tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PodcastCell
        cell.podcast = podcasts[indexPath.item]        
        return cell
    }
    
    //MARK:- SearchBar
   fileprivate func setUpSearchController(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            ApiService.shared.fetchPodcasts(searchText) { (results) in
                self.podcasts = results
                self.tableView.reloadData()
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesViewController = EpisodesViewController()
        episodesViewController.podcast = podcasts[indexPath.item]
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(episodesViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a Search Term"
        label.textColor = UIColor.purple
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let text = searchController.searchBar.text else {return 0}
        return (podcasts.count > 0 || text.isEmpty) ? 0 : 250
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let miniDisplayIsVisible = UIApplication.getMainTabBar()?.miniDisplayIsVisible else {return 0}
        return (podcasts.count > 10 && miniDisplayIsVisible) ? 64 : 0
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.podcasts.removeAll()
        self.tableView.reloadData()
    }
}
