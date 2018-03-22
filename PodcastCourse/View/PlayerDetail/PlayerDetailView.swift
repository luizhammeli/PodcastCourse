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
    
    let scale: CGFloat = 0.7
    
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
    
    @IBOutlet weak var episodeImageView: UIImageView!{
        didSet{
            episodeImageView.layer.cornerRadius = 5            
            episodeImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    @IBOutlet weak var playPauseButton: UIButton!
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
            enlargeEpisodeImageView(enlarge: true)
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            player.play()
        }else{
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            enlargeEpisodeImageView(enlarge: false)
            player.pause()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let time = CMTime(value: 1, timescale: 3)
        let timeValue = NSValue(time: time)
        player.addBoundaryTimeObserver(forTimes: [timeValue], queue: .main) {
            self.enlargeEpisodeImageView(enlarge: true)
        }        
    }
    
    fileprivate func enlargeEpisodeImageView(enlarge: Bool){
        
        let scale = enlarge ? .identity : CGAffineTransform(scaleX: self.scale, y: self.scale)

        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = scale
        }, completion: nil)
    }
}
