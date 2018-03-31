//
//  NSNotificationExtension.swift
//  PodcastCourse
//
//  Created by Luiz Hammerli on 30/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation

extension NSNotification.Name{
    static let updateDownloadsViewControllerName = NSNotification.Name(rawValue: "updateDownloadsViewControllerName")
    static let finishDownloadsViewControllerName = NSNotification.Name(rawValue: "finishDownloadsViewControllerName")
    static let updateDownloadProgressLabelName = NSNotification.Name(rawValue: "updateDownloadProgressLabelName")
    
    static let updateFavoritesController = NSNotification.Name(rawValue: "updateFavoritesController")
    static let updateFavoritesCollectionViewData = NSNotification.Name(rawValue: "updateFavoritesCollectionViewData")
    
    static let playPauseButtonNotificationName = NSNotification.Name(rawValue: "playPauseButton")
    static let fastForwardNotificationName = NSNotification.Name(rawValue: "fastForward")    
}
