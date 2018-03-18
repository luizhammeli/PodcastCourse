//
//  File.swift
//  PodcastCourse
//
//  Created by Luiz Hammerli on 17/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation

extension Date{
    
    func getPodcastDateType()->String{
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "MMMM dd, YYYY"
        return dateFormmater.string(from: self)
    }
}
