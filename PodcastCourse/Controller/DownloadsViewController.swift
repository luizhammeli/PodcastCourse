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
    static let updateDownloadsViewControllerName = NSNotification.Name(rawValue: "updateDownloadsViewControllerName")
    static let finishDownloadsViewControllerName = NSNotification.Name(rawValue: "finishDownloadsViewControllerName")
    var showActivityIndicator = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDownloadsViewControllerData), name: DownloadsViewController.updateDownloadsViewControllerName , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishDownloadsViewController), name: DownloadsViewController.finishDownloadsViewControllerName, object: nil)
        
        episodes = UserDefaults.standard.fetchDownloadedEpisodes()
        self.tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.navigationController?.tabBarItem.badgeValue = nil
    }
    
    @objc func updateDownloadsViewControllerData(){
        episodes = UserDefaults.standard.fetchDownloadedEpisodes()
        self.navigationController?.tabBarItem.badgeValue  = "New"
        self.navigationController?.tabBarItem.badgeColor = .purple
        showActivityIndicator = true
        self.tableView.reloadData()
    }
    
    @objc func finishDownloadsViewController(){
        episodes = UserDefaults.standard.fetchDownloadedEpisodes() 
        showActivityIndicator = false
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
        cell.showActivityIndicator(true)
        if(showActivityIndicator && episodes[indexPath.item].fileUrl.isEmpty){
            cell.showActivityIndicator(!showActivityIndicator)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.getMainTabBar()?.playerDetailView.episode = self.episodes[indexPath.item]
        UIApplication.getMainTabBar()?.maximizedPlayerDetailView()
    }
}

