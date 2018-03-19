//
//  StringExtension.swift
//  PodcastCourse
//
//  Created by iOS Developer on 19/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation

extension String{
    
    func checkHttpsString() ->String{    
        return self.contains("https:") ? self : self.replacingOccurrences(of: "http:", with: "https:")
    }
}
