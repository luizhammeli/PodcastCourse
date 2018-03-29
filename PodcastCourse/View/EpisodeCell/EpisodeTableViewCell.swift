//
//  EpisodeTableViewCell.swift
//  PodcastCourse
//
//  Created by Luiz Hammerli on 17/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit
import FeedKit

class EpisodeTableViewCell: UITableViewCell {
    
    var episode: Episode?{
        didSet{
            guard let episode = episode else {return}
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description
            pubDateLabel.text = episode.pubDate.getPodcastDateType()
            let editedSring = episode.imageUrl.checkHttpsString()
            guard let url = URL(string: editedSring) else {return}
            episodeImageView.sd_setImage(with: url)
        }
    }
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var episodeImageView: UIImageView!    
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            self.titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            self.descriptionLabel.numberOfLines = 2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        episodeImageView.layer.cornerRadius = 4
        episodeImageView.layer.masksToBounds = true
        showActivityIndicator(true)
    }
    
    func showActivityIndicator(_ isHidden: Bool){
        activityIndicator.isHidden = isHidden
        if(isHidden){
            activityIndicator.stopAnimating()
            return
        }
        activityIndicator.startAnimating()
    }
}
