//
//  PodcastCell.swift
//  PodcastCourse
//
//  Created by Luiz Hammerli on 11/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var episodeCount: UILabel!
    @IBOutlet weak var podcastImage: UIImageView!{
        didSet{
            podcastImage.layer.cornerRadius = 4
            podcastImage.layer.masksToBounds = true
        }
    }
    
    var podcast: Podcast?{
        didSet{
            guard let podcast = podcast, let trackCount = podcast.trackCount, let imageUrl = podcast.artworkUrl600 else {return}
            trackName.text = podcast.trackName
            artistName.text = podcast.artistName
            let episode = trackCount > 1 ? "episodes" : "episode"
            episodeCount.text = "\(trackCount) \(episode)"            
            guard let url = URL(string: imageUrl) else {return}
            podcastImage.sd_setImage(with: url, completed: nil)
        }
    }
}
