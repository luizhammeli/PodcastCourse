//
//  Episode.swift
//  PodcastCourse
//
//  Created by iOS Developer on 16/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation
import FeedKit


struct Episode{
    
    let title:String
    let pubDate:Date
    let description: String
    var imageUrl: String
    
    init(_ feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.description = feedItem.description ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href ?? ""
    }
}
