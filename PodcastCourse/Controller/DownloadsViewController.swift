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
        episodes = UserDefaults.standard.fetchDownloadedEpisodes()
        self.tableView.reloadData()
        setUpNotificationCenter()
    }
    
    func setUpNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateDownloadsViewControllerData), name: .updateDownloadsViewControllerName , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishDownloadsViewController), name: .finishDownloadsViewControllerName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateDownloadProgressLabel), name: .updateDownloadProgressLabelName, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.navigationController?.tabBarItem.badgeValue = nil
    }
    
    @objc func updateDownloadProgressLabel(notification: Notification){
        guard let userInfo = notification.userInfo else {return}
        guard let progress = userInfo["progress"] as? Double, let episodeTitle = userInfo["title"] as? String else {return}
        
        guard let cell = getCellByTitle(episodeTitle) else {return}
        
        cell.progressLabel.isHidden = false
        cell.progressLabel.text = "\(Int(progress*100))%"                
    }
    
    func getCellByTitle(_ title: String)-> EpisodeTableViewCell?{
        guard let index = self.episodes.index(where: { return $0.title == title }) else {return nil}
        guard let cell = self.tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? EpisodeTableViewCell else {return nil}
        
        return cell
    }
    
    @objc func updateDownloadsViewControllerData(){
        episodes = UserDefaults.standard.fetchDownloadedEpisodes()
        self.navigationController?.tabBarItem.badgeValue  = "New"
        self.navigationController?.tabBarItem.badgeColor = .purple
        self.tableView.reloadData()
    }
    
    @objc func finishDownloadsViewController(notification: Notification){
        guard let userInfo = notification.userInfo else {return}
        guard let episodeTitle = userInfo["title"] as? String else {return}
        guard let cell = getCellByTitle(episodeTitle) else {return}
        cell.progressLabel.isHidden = true
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.item]
        if(!episode.fileUrl.isEmpty){
            UIApplication.getMainTabBar()?.playerDetailView.episode = episode
            UIApplication.getMainTabBar()?.maximizedPlayerDetailView()
            return
        }
        showAlertController(episode)
    }
    
    fileprivate func showAlertController(_ episode: Episode){
        let alertController = UIAlertController(title: "File URL not found", message: "Cannot find local file, play using stream url instead", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
             UIApplication.getMainTabBar()?.playerDetailView.episode = episode
            UIApplication.getMainTabBar()?.maximizedPlayerDetailView()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removeAction = UITableViewRowAction(style: .destructive, title: "Remove") { (action, index) in
            self.episodes.remove(at: indexPath.item)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            UserDefaults.standard.saveAllEpisodes(episodes: self.episodes)
        }
        
        return [removeAction]
    }
}

