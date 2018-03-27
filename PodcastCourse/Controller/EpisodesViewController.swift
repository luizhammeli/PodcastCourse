
//
//  EpisodesViewController.swift
//  PodcastCourse
//
//  Created by iOS Developer on 14/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesViewController: UITableViewController {
    
    let cellID = "cellID"
    var episodes = [Episode]()
    static let updateFavoritesController = NSNotification.Name(rawValue: "updateFavoritesController")
    var isFavorite = false
    
    var podcast: Podcast?{
        didSet{
            navigationItem.title = podcast?.trackName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        fetchEpisodes()
        setuUpNavigationButtons()
    }
    
    fileprivate func setuUpNavigationButtons(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleSaveButton))
        handleFetchButton()
    }
    
    @objc func handleFetchButton(){
        let podcasts = UserDefaults.fetchFavorites()
        podcasts.forEach { (selectedpodcast) in
            if (selectedpodcast.artworkUrl600 == podcast?.artworkUrl600){
                self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "heart")
                isFavorite = true
                return
            }
        }
    }
    
    @objc func handleSaveButton(){
        var podcasts = UserDefaults.fetchFavorites()
        if (!isFavorite){
            guard let podcast = podcast else {return}
            podcasts.append(podcast)
            UserDefaults.saveFavorites(podcasts)
            self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "heart")
            return
        }
        
        for(index, podcast) in podcasts.enumerated(){
            if (podcast.artistName == self.podcast?.artistName && podcast.trackName == self.podcast?.trackName){
                self.navigationItem.rightBarButtonItem?.image = nil
                self.navigationItem.rightBarButtonItem?.title = "Favorite"
                podcasts.remove(at: index)
                UserDefaults.saveFavorites(podcasts)
                break
            }
        }
    }
    
    func fetchEpisodes(){        
        ApiService.shared.fetchEpisodes(podcast: podcast) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setUpTableView(){
        self.tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "EpisodeTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpisodeTableViewCell
        cell.episode = episodes[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.getMainTabBar()?.playerDetailView.episode = self.episodes[indexPath.item]
        UIApplication.getMainTabBar()?.maximizedPlayerDetailView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let miniDisplayIsVisible = UIApplication.getMainTabBar()?.miniDisplayIsVisible else {return 0}
        return (episodes.count > 2 && miniDisplayIsVisible) ? 64 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = UIColor.darkGray
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return episodes.isEmpty ? 200 : 0
    }
}
