//
//  PlayerDetailView.swift
//  PodcastCourse
//
//  Created by iOS Developer on 21/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit
import FeedKit
import AVFoundation

class PlayerDetailView: UIView {
    
    var episode: Episode?{
        didSet{
            guard let episode = episode else {return}
            episodeLabel.text = episode.title
            guard let url = URL(string: episode.imageUrl.checkHttpsString()) else {return}
            episodeImageView.sd_setImage(with: url)
            authorLabel.text = episode.author
            playEpisode()
        }
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    
    @IBOutlet weak var episodeLabel: UILabel!{
        didSet{
            self.episodeLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBAction func dismissPlayerDetailView(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    fileprivate func playEpisode(){
        guard let episode = episode else {return}
        guard let url = URL(string: episode.streamUrl) else {return}
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        let avItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: avItem)
        player.play()
    }
    
    @IBAction func handlePlayPauseButton(_ sender: Any) {        
        if (player.timeControlStatus == .paused){
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            player.play()
        }else{
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            player.pause()
        }
    }
}
