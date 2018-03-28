//
//  DownloadsViewController.swift
//  PodcastCourse
//
//  Created by iOS Developer on 06/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit

class DownloadsViewController: UITableViewController {
    
    let cellID = "cellID"
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.fetchDownloadedEpisodes()
        self.tableView.reloadData()
    }
    
    //MARK:- Setup
    fileprivate func setUpTableView(){
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

