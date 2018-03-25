//
//  MiniPlayerView.swift
//  PodcastCourse
//
//  Created by Luiz Hammerli on 24/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit

class MiniPlayerView: UIView {
    
    var episode: Episode? {
        didSet{
            guard let episode = episode else {return}
            guard let url = URL(string: episode.imageUrl.checkHttpsString()) else {return}
            mainImageView.sd_setImage(with: url)
            episodeTitleLabel.text = episode.title
        }
    }
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var fastForwardButton: UIButton!
    @IBOutlet weak var mainContainerView: UIView!
    
    static let playPauseButtonNotificationName = NSNotification.Name(rawValue: "playPauseButton")
    static let fastForwardNotificationName = NSNotification.Name(rawValue: "fastForward")
    
    static func loadMiniPlayerViewNib()-> MiniPlayerView{
        return Bundle.main.loadNibNamed("MiniPlayerView", owner: self, options: nil)?.first as! MiniPlayerView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.layer.cornerRadius = 4
        playPauseButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        fastForwardButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    
    @IBAction func handlePlayPauseButton(_ sender: Any) {
        if (playPauseButton.imageView?.image == #imageLiteral(resourceName: "pause")){
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }else{
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        
        NotificationCenter.default.post(name: MiniPlayerView.playPauseButtonNotificationName, object: nil)
    }
    
    @IBAction func handlerFastForwardButton(_ sender: Any) {
        NotificationCenter.default.post(name: MiniPlayerView.fastForwardNotificationName , object: nil)
    }
    
    func setPlayButtonImage(_ image: UIImage){
        playPauseButton.setImage(image, for: .normal)
    }
}
