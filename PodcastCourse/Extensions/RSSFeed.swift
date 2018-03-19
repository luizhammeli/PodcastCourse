//
//  RSSFeed.swift
//  PodcastCourse
//
//  Created by iOS Developer on 19/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import FeedKit

extension RSSFeed{
    
    func getFeedEpisodes()->[Episode]{
        var episodes = [Episode]()
        self.items?.forEach({ (item) in
            var episode = Episode(item)
            if episode.imageUrl.isEmpty{
                guard let feedImage = self.iTunes?.iTunesImage?.attributes?.href else {return}
                episode.imageUrl = feedImage
            }
            episodes.append(episode)
        })
        
        return episodes
    }
}

