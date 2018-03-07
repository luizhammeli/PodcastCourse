//
//  MainTabBarController.swift
//  PodcastCourse
//
//  Created by iOS Developer on 06/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .purple
        UINavigationBar.appearance().prefersLargeTitles = true
        setUpViewControllers()
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
}
