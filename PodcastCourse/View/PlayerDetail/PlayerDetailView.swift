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
    
    let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
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
            episodeImageView.transform = scale
        }
    }
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var podcastDurationLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!
    
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
        addPeriodicTimeObserver()
        addTimeObserver()
    }
    
    func addPeriodicTimeObserver(){
        let time = CMTime(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: time, queue: .main) { (updateTime) in
            self.currentTimeLabel.text = updateTime.toDisplayString()
            self.updateTimeSlider()
            
            if(self.currentTimeLabel.text == self.player.currentItem?.duration.toDisplayString()){                
            }
        }
    }
    
    func addTimeObserver(){
        let time = CMTime(value: 1, timescale: 3)
        let timeValue = NSValue(time: time)
        player.addBoundaryTimeObserver(forTimes: [timeValue], queue: .main) {
            self.enlargeEpisodeImageView(enlarge: true)
            self.podcastDurationLabel.text = self.player.currentItem?.duration.toDisplayString()
        }
    }
    
    func updateTimeSlider(){
        let currentTime = CMTimeGetSeconds(self.player.currentTime())
        let duration = CMTimeGetSeconds(self.player.currentItem?.duration ?? CMTime(value: 1, timescale: 1))
        let percent = currentTime/duration
        currentTimeSlider.value = Float(percent)
    }
    
    fileprivate func enlargeEpisodeImageView(enlarge: Bool){
        
        let scale = enlarge ? .identity : self.scale

        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = scale
        }, completion: nil)
    }
    
    @IBAction func CurrentTimeSliderValueChanged(_ sender: Any) {
        guard let slider = sender as? UISlider, let duration = player.currentItem?.duration else{return}
        let currentTimeSeconds = CMTimeGetSeconds(duration)
        let percent = Float64(slider.value) * currentTimeSeconds
        player.seek(to: CMTimeMakeWithSeconds(percent, 1))
    }
        
    
    @IBAction func handleFastRewindButton(_ sender: Any) {
    }
    
    
}
