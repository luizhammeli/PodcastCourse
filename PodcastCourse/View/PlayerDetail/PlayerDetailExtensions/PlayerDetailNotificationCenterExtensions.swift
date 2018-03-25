//
//  PlayerDetailNotificationCenterExtensions.swift
//  PodcastCourse
//
//  Created by Luiz Hammerli on 24/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit

extension PlayerDetailView{
    func addFeedNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayPauseButton), name:MiniPlayerView.playPauseButtonNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFastButton), name:MiniPlayerView.fastForwardNotificationName, object: nil)
    }
}
