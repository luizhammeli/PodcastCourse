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
    let miniPlayerView = MiniPlayerView.loadMiniPlayerViewNib()
    var panGesture:UIPanGestureRecognizer?

    var episode: Episode?{
        didSet{
            guard let episode = episode else {return}
            episodeLabel.text = episode.title
            guard let url = URL(string: episode.imageUrl.checkHttpsString()) else {return}
            episodeImageView.sd_setImage(with: url)
            authorLabel.text = episode.author
            miniPlayerView.episode = episode
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
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var playPauseButton: UIButton!{
        didSet{
            playPauseButton.transform = scale
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var podcastDurationLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!
    
    fileprivate func playEpisode(){
        guard let episode = episode else {return}
        if(!episode.fileUrl.isEmpty){
            guard let url = URL(string: episode.fileUrl) else {return}
            guard var location = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            location.appendPathComponent(url.lastPathComponent)
            playAudio(location)
        }else{
            guard let url = URL(string: episode.streamUrl) else {return}
            playAudio(url)
        }
    }
    
    func playAudio(_ url: URL){
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        let avItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: avItem)
        player.play()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addPeriodicTimeObserver()
        addTimeObserver()
        setUpPLayerView()
        addFeedNotification()
        addGesturesRecognizer()
    }
    
    func addPeriodicTimeObserver(){
        let time = CMTime(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] (updateTime)  in
            self?.currentTimeLabel.text = updateTime.toDisplayString()
            self?.updateTimeSlider()
        }
    }
    
    func addTimeObserver(){
        let time = CMTime(value: 1, timescale: 3)
        let timeValue = NSValue(time: time)
        player.addBoundaryTimeObserver(forTimes: [timeValue], queue: .main) {
            [weak self] in
            self?.enlargeEpisodeImageView(enlarge: true)
            self?.podcastDurationLabel.text = self?.player.currentItem?.duration.toDisplayString()
        }
    }
    
    func setUpPLayerView(){
        miniPlayerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(miniPlayerView)
        miniPlayerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        miniPlayerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        miniPlayerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        miniPlayerView.heightAnchor.constraint(equalToConstant: 64).isActive = true
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
    
    fileprivate func fastRewindPodcast(time: Int64){
        let seekTime = CMTimeAdd(player.currentTime(), CMTimeMake(time, 1))
        player.seek(to: seekTime)
    }
    
    static func loadNibFile() -> PlayerDetailView{
        return Bundle.main.loadNibNamed("PlayerDetailView", owner: self, options: nil)?.first as! PlayerDetailView
    }    
    
    //MARK:- IBActions
    @IBAction func CurrentTimeSliderValueChanged(_ sender: UISlider) {
        guard let duration = player.currentItem?.duration else{return}
        let currentTimeSeconds = CMTimeGetSeconds(duration)
        let percent = Float64(sender.value) * currentTimeSeconds
        player.seek(to: CMTimeMakeWithSeconds(percent, 1))
    }
    
    @IBAction func handleFastButton(_ sender: Any) {
        fastRewindPodcast(time: 15)
    }
    
    @IBAction func handleRewindButton(_ sender: Any) {
        fastRewindPodcast(time: -15)
    }
    
    @IBAction func volumeSliderValueChanged(_ sender: UISlider) {
        self.player.volume = sender.value
    }
    
    @IBAction func dismissPlayerDetailView(_ sender: Any) {
        UIApplication.getMainTabBar()?.minimizedPlayerDetailView()
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
}
