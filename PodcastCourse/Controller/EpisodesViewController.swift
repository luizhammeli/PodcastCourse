
//
//  EpisodesViewController.swift
//  PodcastCourse
//
//  Created by iOS Developer on 14/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit

class EpisodesViewController: UITableViewController {
    
    let cellID = "cellID"
    
    let episodes = ["ep1", "ep2", "ep2"]
    
    var podcast: Podcast?{
        didSet{
            navigationItem.title = podcast?.trackName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    func setUpTableView(){
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = episodes[indexPath.item]
        return cell
    }
}
