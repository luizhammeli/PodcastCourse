//
//  MainTabBarController.swift
//  PodcastCourse
//
//  Created by iOS Developer on 06/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController{
    
    var maxTopConstraint: NSLayoutConstraint!
    var minTopConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    let playerDetailView = PlayerDetailView.loadNibFile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .purple
        UINavigationBar.appearance().prefersLargeTitles = true
        setUpViewControllers()
        setUpDetailView()
    }
    
    @objc func maximizedPlayerDetailView(){
        minTopConstraint.isActive = false
        maxTopConstraint.isActive = true
        maxTopConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)            
            self.playerDetailView.mainStackView.alpha = 1
            self.playerDetailView.miniPlayerView.alpha = 0
        }, completion: nil)
    }
    
    @objc func minimizedPlayerDetailView(){
        maxTopConstraint.isActive = false
        bottomAnchorConstraint.constant = self.view.frame.height
        minTopConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.playerDetailView.mainStackView.alpha = 0
            self.playerDetailView.miniPlayerView.alpha = 1
            self.playerDetailView.miniPlayerView.setPlayButtonImage((self.playerDetailView.playPauseButton.imageView?.image)!) 
        }, completion: nil)
    }
    
    //MARK:- Setup Function
    func setUpViewControllers(){
        self.viewControllers = [setUpTabBarItens(rootViewController: FavoritesController(collectionViewLayout: UICollectionViewFlowLayout()), title: "Favorites", image: #imageLiteral(resourceName: "favorites")), setUpTabBarItens(rootViewController: SearchViewController() , title: "Search", image: #imageLiteral(resourceName: "search")), setUpTabBarItens(rootViewController: ViewController() , title: "Downloads", image:#imageLiteral(resourceName: "downloads"))]
    }
    
    fileprivate func setUpTabBarItens(rootViewController: UIViewController, title: String, image: UIImage)->UIViewController{
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
    
    func setUpDetailView(){
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(playerDetailView, belowSubview: tabBar)
        
        maxTopConstraint = playerDetailView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height)
        minTopConstraint = playerDetailView.topAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: -64)
        playerDetailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        playerDetailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomAnchorConstraint = playerDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.view.frame.height)
        
        maxTopConstraint.isActive = true
        bottomAnchorConstraint.isActive = true
    }
}
