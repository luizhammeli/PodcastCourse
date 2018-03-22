//
//  CMTimeExtension.swift
//  PodcastCourse
//
//  Created by iOS Developer on 22/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import AVFoundation

extension CMTime{
    
    func toDisplayString() -> String {        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let hours = totalSeconds / 60 / 60        
        return String(format: "%02d:%02d:%02d" , hours, minutes, seconds)
    }
}
