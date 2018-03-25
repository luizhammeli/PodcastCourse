//
//  UIApplication.swift
//  PodcastCourse
//
//  Created by Luiz Hammerli on 25/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit


extension UIApplication{
    
    static func getMainTabBar()->MainTabBarController?{
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
