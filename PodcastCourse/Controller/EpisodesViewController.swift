
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
    
    var podcast: Podcast?{
        didSet{
            navigationItem.title = podcast?.trackName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        fetchEpisodes()
    }
    
    func fetchEpisodes(){
        guard let stringUrl = podcast?.feedUrl else {return}
        let editedSring = stringUrl.replacingOccurrences(of: "http:", with: "https:")
        guard let url = URL(string: editedSring) else {return}
        let parser = FeedParser(URL: url)
        parser?.parseAsync(result: { (result) in
            switch result {
                case let .rss(feed):
                    feed.items?.forEach({ (item) in
                        var episode = Episode(item)
                        if episode.imageUrl.isEmpty{
                            guard let feedImage = feed.iTunes?.iTunesImage?.attributes?.href else {return}
                            episode.imageUrl = feedImage
                        }
                        self.episodes.append(episode)
                    })
                    break
                case .failure(_): break
                default: break
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
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
}
