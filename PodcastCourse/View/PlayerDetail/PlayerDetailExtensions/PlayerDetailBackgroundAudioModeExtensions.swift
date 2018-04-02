//
//  PlayerDetailAvAudioExtensions.swift
//  PodcastCourse
//
//  Created by Mac on 01/04/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer


extension PlayerDetailView{
    func setUpAudioSession(){
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch let err{
            print(err)
        }
    }
    
    func setUpRemoteControl(){
        let commandCenter = MPRemoteCommandCenter.shared()
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget(handler: playPauseAudio)
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget(handler: playPauseAudio)
        
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget(handler: playPauseAudio)
    }
    
    fileprivate func playPauseAudio(command: MPRemoteCommandEvent)->MPRemoteCommandHandlerStatus{
        self.handlePlayPauseButton(self)
        return .success
    }
    
}
