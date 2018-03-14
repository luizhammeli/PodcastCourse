//
//  PodcastCell.swift
//  PodcastCourse
//
//  Created by Luiz Hammerli on 11/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var episodeCount: UILabel!
    @IBOutlet weak var podcastImage: UIImageView!
    
    var podcast: Podcast?{
        didSet{
            guard let podcast = podcast else {return}            
            trackName.text = podcast.trackName
            artistName.text = podcast.artistName
        }
    }
    
}
