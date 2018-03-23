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
    let playerDetailView = PlayerDetailView.loadNibFile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .purple
        UINavigationBar.appearance().prefersLargeTitles = true
        setUpViewControllers()
        setUpDetailView()
        perform(#selector(maximizedPlayerDetailView), with: self, afterDelay: 1)
    }
    

    
    @objc func maximizedPlayerDetailView(){
        maxTopConstraint.constant = 0
        maxTopConstraint.isActive = true
        minTopConstraint.isActive = false
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
        }, completion: nil)
    }
    
    @objc func minimizedPlayerDetailView(){
        maxTopConstraint.isActive = false
        minTopConstraint.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
        }, completion: nil)
    }
    
    //MARK:- Setup Function
    func setUpViewControllers(){
        self.viewControllers = [setUpTabBarItens(rootViewController: SearchViewController() , title: "Search", image: #imageLiteral(resourceName: "search")),setUpTabBarItens(rootViewController: ViewController() , title: "Favorites", image: #imageLiteral(resourceName: "favorites")), setUpTabBarItens(rootViewController: ViewController() , title: "Downloads", image:#imageLiteral(resourceName: "downloads"))]
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
        //playerDetailView.backgroundColor = .red
        self.view.insertSubview(playerDetailView, belowSubview: tabBar)
        maxTopConstraint = playerDetailView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height)
        maxTopConstraint.isActive = true
        minTopConstraint = playerDetailView.topAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: -64)
        
        playerDetailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        playerDetailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        playerDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}
